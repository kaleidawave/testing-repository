# Install hyperfine
brew install hyperfine

echo "::group::Get tools"

# TODO flow, hegel, install tools (or cache better), more

echo "::group::Build STC"

# [ -f cached_targets/stc ] && mv cached_targets/stc stc/target
rustup toolchain install nightly-2023-06-20

git clone https://github.com/dudykr/stc stc
cd stc
git reset --hard 693cf5a891c5580542811b906616f0c15d0dd0fc
cd ..

# Fix
cargo add --manifest-path stc/crates/stc/Cargo.toml clap@=4.3.0
cargo add --manifest-path stc/crates/stc/Cargo.toml clap_derive@=4.3.0
cargo add --manifest-path stc/crates/stc/Cargo.toml clap_builder@=4.3.0
cargo add --manifest-path stc/crates/stc/Cargo.toml clap_lex@=0.5
cargo add --manifest-path stc/crates/stc/Cargo.toml triomphe@=0.1.8

cargo +nightly-2023-06-20 install --path stc/crates/stc --no-default-features 

./stc/target/release/stc --help

echo "::endgroup::"

echo "::group::Build Ezno (and demo.tsx)"
rustc --version
rustup toolchain install stable
# rustup toolchain install 1.75.0

# [ -f cached_targets/ezno ] && mv cached_targets/ezno ezno/target

# mkdir -p ./ezno2/target/release
# gh release download -R kaleidawave/ezno -p "*.exe" -O ezno
# mv ezno ./ezno2/target/release
# mv ezno2 ezno
# ls ezno

git clone -b parser-improvements-036 https://github.com/kaleidawave/ezno.git ezno

cargo build --manifest-path ezno/Cargo.toml --release --bin ezno

# cargo install --path ezno

./ezno/target/release/ezno info

echo "::group::Build demo.tsx"
cargo run --manifest-path ezno/Cargo.toml -p ezno-parser --example code_blocks_to_script ./ezno/checker/specification/specification.md --comment-headers --out ./demo.tsx

echo "<details>
<summary>Input</summary>

\`\`\`ts
$(cat ./demo.tsx)
\`\`\`

</details>
" >> $GITHUB_STEP_SUMMARY

cat "const x: string = 4;" >> simple.tsx

# rg --passthru -N 'satisfies' -r 'as' ./demo.tsx > ./demo-flow.js

echo "::endgroup::"

echo "::endgroup::"

echo "::group::Get TSC"

npm install -g typescript

echo "::endgroup"

echo "::endgroup"
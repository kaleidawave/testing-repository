# Install hyperfine
brew install hyperfine

echo "::group::Get tools"

# TODO flow, hegel, install tools (or cache better), more

# [ -f cached_targets ] && ls cached_targets

echo "::group::Build Ezno"
rustc --version
rustup toolchain install stable
# rustup toolchain install 1.75.0

# [ -f cached_targets/ezno ] && mv cached_targets/ezno ezno/target

# mkdir -p ./ezno2/target/release
# gh release download -R kaleidawave/ezno -p "*.exe" -O ezno
# mv ezno ./ezno2/target/release
# mv ezno2 ezno
# ls ezno

git clone https://github.com/kaleidawave/ezno ezno

cargo build --manifest-path ezno/Cargo.toml --release --bin ezno

# cargo install --path ezno

./ezno/target/release/ezno info

echo "::group::Build demo.ts"
cargo run --manifest-path ezno/Cargo.toml -p ezno-parser --example code_blocks_to_script ./ezno/checker/specification/specification.md ./demo.ts

echo "<details>
<summary>Input</summary>

\`\`\`ts
$(cat ./demo.ts)
\`\`\`

</details>
" >> $GITHUB_STEP_SUMMARY

# rg --passthru -N 'satisfies' -r 'as' ./demo.ts > ./demo-flow.js

echo "::endgroup::"

echo "::endgroup::"

# npm install -g oxidation-compiler@latest

echo "::group::Build STC"
git clone https://github.com/dudykr/stc stc
cd stc
git reset --hard 693cf5a891c5580542811b906616f0c15d0dd0fc
cd ..
# [ -f cached_targets/stc ] && mv cached_targets/stc stc/target

rustup toolchain install nightly-2023-06-20
cargo +nightly-2023-06-20 install --path stc/crates/stc

./stc/target/release/stc --help
echo "::endgroup::"

echo "::group::Get TSC"
npm install -g typescript
echo "::endgroup"

echo "::endgroup"
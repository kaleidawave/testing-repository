# Install hyperfine
brew install hyperfine

echo "::group::Get tools"

# TODO flow, hegel, install tools (or cache better), more

# echo "::group::Build STC"

# rustup toolchain install nightly-2023-06-20

# git clone https://github.com/dudykr/stc stc
# cd stc
# git reset --hard 693cf5a891c5580542811b906616f0c15d0dd0fc
# cd ..

# cargo +nightly-2023-06-20 build --manifest-path stc/crates/stc/Cargo.toml --no-default-features --locked

# ./stc/target/release/stc --help

# echo "::endgroup::"

echo "::group::Build Ezno (and demo.tsx)"
rustc --version
rustup toolchain install stable

# [ -f cached_targets/ezno ] && mv cached_targets/ezno ezno/target

# mkdir -p ./ezno2/target/release
# gh release download -R kaleidawave/ezno -p "*.exe" -O ezno
# mv ezno ./ezno2/target/release
# mv ezno2 ezno
# ls ezno

# Main
git clone https://github.com/kaleidawave/ezno.git ezno -b main

cargo build --manifest-path ezno/Cargo.toml --release --bin ezno

# and new parser
git clone https://github.com/kaleidawave/ezno.git ezno-next -b merge-lexer
cargo build --manifest-path ezno-next/Cargo.toml --release --bin ezno

# cargo install --path ezno

./ezno/target/release/ezno info
./ezno/target/release/ezno-next info

echo "::group::Build demo files"
cargo run --manifest-path ezno/Cargo.toml \
    -p ezno-parser --example code_blocks_to_script ./ezno/checker/specification/specification.md \
    --comment-headers --out ./demo.tsx

cat demo.tsx demo.tsx demo.tsx > dēmo.tsx

cp ./demo.tsx $ARTIFACTS_FOLDER

# # Simple
# echo "const x: string = 4;" >> simple.tsx

# # Large
# for i in {1..10}; do
#     cat ./demo.tsx >> ./large.tsx
# done

# echo "interface Array {}
# interface Boolean {}
# interface Function {}
# interface IArguments {}
# interface Number {}
# interface Object {}
# interface RegExp {}
# interface String {}" > overrides.d.ts

# mkdir all
# cargo run --manifest-path ezno/Cargo.toml -p ezno-parser --example code_blocks_to_script ./ezno/checker/specification/specification.md --into-files all ts

# ls all
# # --repeat 50

echo "::endgroup::"

echo "::endgroup::"

echo "::group::Get TSC"

npm install -g typescript

echo "::endgroup"

echo "::endgroup"
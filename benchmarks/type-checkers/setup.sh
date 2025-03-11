# Install hyperfine
brew install hyperfine

echo "::group::Get tools"

echo "::group::Build Ezno (and demo.tsx)"
rustc --version
rustup toolchain install stable

# ezno main
git clone https://github.com/kaleidawave/ezno.git ezno -b general-fixes
cargo build --manifest-path ezno/Cargo.toml --release --bin ezno
./ezno/target/release/ezno info

# and new parser
# git clone https://github.com/kaleidawave/ezno.git ezno-next -b merge-lexer
# cargo build --manifest-path ezno-next/Cargo.toml --release --bin ezno
# cargo install --path ezno
# ./ezno/target/release/ezno-next info

echo "::endgroup::"

# ---

echo "::group::Get (old) TSC"

npm i -g typescript

echo "::endgroup"

# ---

echo "::group::Get (new) TSC"

# new tsc
git clone --recurse-submodules https://github.com/microsoft/typescript-go.git .
git submodule update --init --recursive
hereby build

echo "::endgroup"

# ---

echo "::endgroup::"

# ---

echo "::group::Build demo files"
cargo run --manifest-path ezno/Cargo.toml \
    -p ezno-parser --example code_blocks_to_script ./ezno/checker/specification/specification.md \
    --comment-headers --out ./demo.tsx

cp ./demo.tsx $ARTIFACTS_FOLDER

for i in {1..10}; do
    cat ./demo.tsx >> large.tsx
done

cp ./large.tsx $ARTIFACTS_FOLDER

# # Simple
# echo "const x: string = 4;" >> simple.tsx

# # Large
# for i in {1..10}; do
#     cat ./demo.tsx >> ./large.tsx
# done

# echo "interface Array {}; interface Boolean {}; interface Function {}; interface IArguments {}; interface Number {}; interface Object {}; interface RegExp {}; interface String {}" > overrides.d.ts

# mkdir all
# cargo run --manifest-path ezno/Cargo.toml -p ezno-parser --example code_blocks_to_script ./ezno/checker/specification/specification.md --into-files all ts

# ls all
# # --repeat 50

echo "::endgroup::"
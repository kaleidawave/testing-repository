echo "::group::Get tools"
# Install hyperfine
brew install hyperfine
sudo apt-get install valgrind

echo "::endgroup::"

# ---

echo "::group::Build checkers"

echo "::group::Build Ezno (and demo.tsx)"

rustc --version
rustup toolchain install stable

date

ls

echo "nnnnn"

ls ezno

# ezno main
if [ -d "ezno" ]; then
    cd ezno
    git init
    git remote add origin https://github.com/kaleidawave/ezno.git
    git fetch
    git checkout origin/general-fixes -ft
    cd ..
else
    git clone https://github.com/kaleidawave/ezno.git ezno -b general-fixes
fi

cargo build --manifest-path ezno/Cargo.toml --release --bin ezno
./ezno/target/release/ezno info

date

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

date

# new tsc
if [ -d "tsc-go" ]; then
    cd tsc-go
    git init
    git remote add origin https://github.com/microsoft/typescript-go.git
    git fetch
    git checkout origin/main -ft
    cd ..
else
    git clone --recurse-submodules https://github.com/microsoft/typescript-go.git tsc-go
fi

cd tsc-go
git submodule update --init --recursive
npm i
npm run build
cd ..

date

echo "::endgroup"

# ---

echo "::endgroup::"

# ---

echo "::group::Build demo files"

date

cargo run --manifest-path ezno/Cargo.toml \
    -p ezno-checker-specification \
    --example amalgamate ezno/checker/specification/specification.md \
    --comment-headers \
    --repeat 1 \
    --out ./demo.ts

cp ./demo.ts $ARTIFACTS_FOLDER

cargo run --manifest-path ezno/Cargo.toml \
    -p ezno-checker-specification \
    --example amalgamate ezno/checker/specification/specification.md \
    --comment-headers \
    --repeat 40 \
    --out ./large.ts

cp ./large.ts $ARTIFACTS_FOLDER

date

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
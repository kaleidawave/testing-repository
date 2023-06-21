# Install hyperfine
brew install hyperfine

# Setup tools
echo "::group::Build stc"
git clone https://github.com/dudykr/stc stc
rustup toolchain install nightly
# --release
cargo +nightly build --manifest-path stc/crates/stc/Cargo.toml
echo "::endgroup::"

npm install -g oxidation-compiler@latest
npm install -g typescript

# Get demo.ts
echo "::group::Get demo.ts"
curl https://gist.githubusercontent.com/kaleidawave/5dcb9ec03deef1161ebf0c9d6e4b88d8/raw/26c26e908a7c6b79a2e93627f1fefa7ffccbd389/demo.ts > demo.ts
echo "::endgroup::"

echo "::group::Run tools"
echo "Ezno:"
oxidation-compiler check demo.ts
echo "TSC:"
tsc demo.ts
echo "STC:"
./stc/target/release/stc demo.ts
echo "::endgroup::"

# Run benchmark
hyperfine -i 'oxidation-compiler check ./demo.ts' 'tsc demo.ts' 'stc/target/release/stc demo.ts'

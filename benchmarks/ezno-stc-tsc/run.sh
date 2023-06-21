# Setup
git clone https://github.com/dudykr/stc stc
cargo build --release --manifest-path stc/crates/stc/Cargo.toml

ls ./stc/target/release

npm install -g oxidation-compiler@latest
npm install -g typescript

# Get demo.ts

curl https://gist.githubusercontent.com/kaleidawave/5dcb9ec03deef1161ebf0c9d6e4b88d8/raw/26c26e908a7c6b79a2e93627f1fefa7ffccbd389/demo.ts > demo.ts

# Run benchmark
hyperfine -i 'oxidation-compiler check .\demo.ts' 'tsc demo.ts' 'stc/target/release/stc demo.ts'

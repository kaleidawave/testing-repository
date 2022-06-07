# Installation
brew install hyperfine

# Rust 
cargo build --release

hyperfine "./target/release/main" "node index.js" > "$ARTIFACTS_FOLDER/hyperfine.output.1.txt"

# Installation
brew install hyperfine

# Rust 
cargo build --release

hyperfine "./target/release/main" "node index.js"

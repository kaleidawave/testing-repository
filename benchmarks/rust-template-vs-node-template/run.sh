# Installation
brew install hyperfine

# Rust setup
cargo build --release

ls -R target > "$ARTIFACTS_FOLDER/ls.txt"

hyperfine "./target/release/main" "node index.js" > "$ARTIFACTS_FOLDER/hyperfine.output.txt"

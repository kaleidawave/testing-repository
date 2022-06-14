# Installation
brew install hyperfine

# Rust setup
cargo build --release

hyperfine "./target/release/main" "node index.js" > "$ARTIFACTS_FOLDER/hyperfine.output.txt"

# Temp :)

brew install asciinema

asciinema rec -c "hyperfine './target/release/main' 'node index.js'" "$ARTIFACTS_FOLDER/recording"

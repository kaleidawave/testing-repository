# Install hyperfine
brew install hyperfine

# export CURRENT_TARGET='trunk'
# cargo tree
cargo build --bin codespan-reporting-benchmark --release
mv target/release/codespan-reporting-benchmark bin-main

# Build new version
export COMPACT="true"
cargo build --bin codespan-reporting-benchmark --release
mv target/release/codespan-reporting-benchmark bin-compact

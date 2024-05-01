# Install hyperfine
brew install hyperfine

cargo build --bin codespan-reporting-benchmark --release
mv target/release/codespan-reporting-benchmark bin-main

export COMPACT=1
cargo build --bin codespan-reporting-benchmark --release
mv target/release/codespan-reporting-benchmark bin-compact
unset COMPACT

export BUFFERED=1
cargo build --bin codespan-reporting-benchmark --release
mv target/release/codespan-reporting-benchmark bin-buffered
unset BUFFERED

export LOCKED=1
cargo build --bin codespan-reporting-benchmark --release
mv target/release/codespan-reporting-benchmark bin-locked
unset LOCKED
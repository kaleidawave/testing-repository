brew install hyperfine

# Rust run
cargo build --features tracing &&
cargo build --release --features tracing

npm install
for i in {1..5}
do
  ./target/debug/image-generation 2> >(tee -a "$ARTIFACTS_FOLDER/resvg-debug-output.txt")
  ./target/release/image-generation 2> >(tee -a "$ARTIFACTS_FOLDER/resvg-release-output.txt")
  node index.js >>"$ARTIFACTS_FOLDER/node-release-output-$i.txt"
  echo "" >> "$ARTIFACTS_FOLDER/resvg-debug-output.txt"
  echo "" >> "$ARTIFACTS_FOLDER/resvg-release-output.txt"
done

cargo build --release

set SINGLE_RUN=true

hyperfine "./target/release/image-generation" "node index.js" >> "$ARTIFACTS_FOLDER/hyperfine.txt"
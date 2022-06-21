brew install hyperfine

# Rust run
cargo build --features tracing
cargo build --release --features tracing

for i in {1..5}
do
  ./target/debug/image-generation 2> >(tee -a "$ARTIFACTS_FOLDER/resvg-debug-output.txt")
  ./target/release/image-generation 2> >(tee -a "$ARTIFACTS_FOLDER/resvg-release-output.txt")
  echo "\n" >> "$ARTIFACTS_FOLDER/resvg-debug-output.txt"
  echo "\n" >> "$ARTIFACTS_FOLDER/resvg-release-output.txt"
done

cargo build --release

npm install
node index.js >> "$ARTIFACTS_FOLDER/puppetteer-output.txt"

hyperfine "./target/release/image-generation" "node index.js" >> "$ARTIFACTS_FOLDER/hyperfine.txt"
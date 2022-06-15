cargo install

# Rust run
cargo build --release

for i in {1..5}
do
  ./target/release/image-generation 2>&1 >> "$ARTIFACTS_FOLDER/resvg-output.txt"
done

npm ci || npm install
node index.js >> "$ARTIFACTS_FOLDER/puppetteer-output.txt"
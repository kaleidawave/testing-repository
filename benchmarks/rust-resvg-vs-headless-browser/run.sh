cargo install

# Rust run
cargo build --release

for i in {1..5}
do
  ./target/release/image-generation 2> >(tee -a "$ARTIFACTS_FOLDER/resvg-output.txt")
done

npm ci || npm install
node index.js >> "$ARTIFACTS_FOLDER/puppetteer-output.txt"
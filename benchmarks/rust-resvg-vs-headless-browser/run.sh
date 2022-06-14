cargo install

# Rust run
cargo build --release

for i in {1..5}
do
  ./target/release/image-generation
done

npm ci
node index.js
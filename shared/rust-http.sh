# Installation
brew install wrk

rustup toolchain install nightly
rustup default nightly

folder=$(basename $(pwd))

# Temp disable for cached target
mv target target-ignored

# Cold build
cargo -Z unstable-options build --timings=html
# Replace string literals
sed 's/"Hello World"/"Hello Planet"/' $"$folder/src/main.rs" > $"$folder/src/main.rs"
# Incremental build (right?)
cargo -Z unstable-options build --timings=html

# Release build + timings
cargo -Z unstable-options build --release --timings=html

artifacts="artifacts/$folder"

mkdir $"$artifacts/timings"
mv target/cargo-timings/* "$artifacts/timings"

path="./target/debug/$folder"
$path &

# pause for server to startup
sleep 10

# Run benchmark 3x
wrk -t12 -c200 -d30s http://127.0.0.1:3000 > $"$artifacts/wrk.output.1.txt"
sleep 10
wrk -t12 -c200 -d30s http://127.0.0.1:3000 > $"$artifacts/wrk.output.2.txt"
sleep 10
wrk -t12 -c200 -d30s http://127.0.0.1:3000 > $"$artifacts/wrk.output.3.txt"
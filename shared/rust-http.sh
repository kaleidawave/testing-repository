# Installation
brew install wrk

rustup toolchain install nightly
rustup default nightly

# Temp disable for cached target
mv target target-ignored
mkdir $ARTIFACTS_FOLDER/build-timings $ARTIFACTS_FOLDER/wrk

# Cold build
cargo -Z unstable-options build --timings=html
mv target/cargo-timings/cargo-timing.html "$ARTIFACTS_FOLDER/build-timings/cold-build-timing.html"

# Replace string literals
sed -i 's/"Hello World"/"Hello Planet"/' src/main.rs
# Incremental build (right?)
cargo -Z unstable-options build --timings=html

mv target/cargo-timings/cargo-timing.html "$ARTIFACTS_FOLDER/build-timings/incremental-build.html"

# Release build + timings
cargo -Z unstable-options build --release --timings=html

mv target/cargo-timings/cargo-timing.html "$ARTIFACTS_FOLDER/build-timings/debug-to-release-build.html"

# Execute server
$($(find target/debug/*.exe)) &

# pause for server to startup
sleep 10

# Run benchmark 3x
wrk -t12 -c200 -d30s http://127.0.0.1:3000 > "$ARTIFACTS_FOLDER/wrk/output.1.txt"
sleep 10
wrk -t12 -c200 -d30s http://127.0.0.1:3000 > "$ARTIFACTS_FOLDER/wrk/output.2.txt"
sleep 10
wrk -t12 -c200 -d30s http://127.0.0.1:3000 > "$ARTIFACTS_FOLDER/wrk/output.3.txt"

curl -v http://127.0.0.1:3000/ > "$ARTIFACTS_FOLDER/wrk/curl.txt"
curl -v http://127.0.0.1:3000/counter.json > "$ARTIFACTS_FOLDER/wrk/curl-counter.txt"
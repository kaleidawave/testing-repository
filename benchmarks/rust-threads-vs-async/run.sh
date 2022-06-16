# Install prerequisites
brew install hyperfine
brew install caddy

cargo build --release
mv target/release/bin sync

cargo build --release --features threads
mv target/release/bin threads

cargo build --release --features async
mv target/release/bin async

cargo build --release --features async,threads
mv target/release/bin async_threads

caddy start

hyperfine --warmup 3 ./sync ./threads ./async ./async_threads > "$ARTIFACTS_FOLDER/hyperfine-output-$NUM_REQUESTS.txt"
export NUM_REQUESTS=100
hyperfine --warmup 3 ./sync ./threads ./async ./async_threads > "$ARTIFACTS_FOLDER/hyperfine-output-$NUM_REQUESTS.txt"
export NUM_REQUESTS=1000
hyperfine --warmup 3 ./sync ./threads ./async ./async_threads > "$ARTIFACTS_FOLDER/hyperfine-output-$NUM_REQUESTS.txt"
export NUM_REQUESTS=10000
hyperfine --warmup 3 ./sync ./threads ./async ./async_threads > "$ARTIFACTS_FOLDER/hyperfine-output-$NUM_REQUESTS.txt"

caddy stop
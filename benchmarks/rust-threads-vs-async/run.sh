# Installation
brew install hyperfine

# Make some files
mkdir files
for i in {1..10000}
do
  cp run.sh "files/$i" 
done

cargo build --release
mv target/release/rust-threads-vs-async sync

cargo build --release --features threads
mv target/release/rust-threads-vs-async threads

cargo build --release --features async
mv target/release/rust-threads-vs-async async

cargo build --release --features async,threads
mv target/release/rust-threads-vs-async async_threads

export NUM_FILES = 100
hyperfine --warmup 3 ./sync ./threads ./async ./async_threads > "$ARTIFACTS_FOLDER/hyperfine-output-$NUM_FILES.txt"

export NUM_FILES = 1000
hyperfine --warmup 3 ./sync ./threads ./async ./async_threads > "$ARTIFACTS_FOLDER/hyperfine-output-$NUM_FILES.txt"

export NUM_FILES = 10000
hyperfine --warmup 3 ./sync ./threads ./async ./async_threads > "$ARTIFACTS_FOLDER/hyperfine-output-$NUM_FILES.txt"
# Installation
brew install hyperfine

# Make some files
mkdir files
for i in `seq 1 $((10**5))`
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

hyperfine --warmup 3 ./sync ./threads ./async ./async_threads > "$ARTIFACTS_FOLDER/hyperfine-output.txt"
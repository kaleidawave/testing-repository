cargo build --release
for i in {1..10} 
do
    ./target/release/bin >> "$ARTIFACTS_FOLDER/tokio-startup.txt"
done
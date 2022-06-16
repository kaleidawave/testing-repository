cargo build --release
for i in {1..10} 
do
    ./target/release/bin >> "Run $i:"
    ./target/release/bin >> "$ARTIFACTS_FOLDER/tokio-startup.txt"
    ./target/release/bin >> "\n"
done
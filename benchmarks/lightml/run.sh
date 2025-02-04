./target/release/example &> $GITHUB_STEP_SUMMARY

hyperfine ./target/release/example &> $GITHUB_STEP_SUMMARY

valgrind --log-file="$ARTIFACTS_FOLDER/out-mem.txt" ./target/release/example
valgrind --tool=callgrind --callgrind-out-file="$ARTIFACTS_FOLDER/out-cpu.txt" ./target/release/example

# samply record -s -o "$ARTIFACTS_FOLDER/out-samply.json.gz" ./target/release/example
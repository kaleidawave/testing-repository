PROFILES="release,debug"

CODE_FENCE='```'
OUTPUT="
### Output
"$CODE_FENCE"shell
$(./target/release/example 2>&1)
$CODE_FENCE

### Hyperfine
"$CODE_FENCE"shell
$(hyperfine -L profile $PROFILES './target/{profile}/example')
$CODE_FENCE"

echo "$OUTPUT" > $GITHUB_STEP_SUMMARY

valgrind --log-file="$ARTIFACTS_FOLDER/out-mem-release.txt" ./target/release/example
valgrind --tool=callgrind --callgrind-out-file="$ARTIFACTS_FOLDER/out-cpu-release.txt" ./target/release/example

valgrind --log-file="$ARTIFACTS_FOLDER/out-mem-debug.txt" ./target/debug/example
valgrind --tool=callgrind --callgrind-out-file="$ARTIFACTS_FOLDER/out-cpu-debug.txt" ./target/debug/example

# Analyse results
rg "summary: (.*)" -or '$1' -N --color never $ARTIFACTS_FOLDER/out-cpu-debug.txt
rg "summary: (.*)" -or '$1' -N --color never $ARTIFACTS_FOLDER/out-cpu-release.txt

rg "([0-9,]*) bytes allocated" -or '$1' -N --color never $ARTIFACTS_FOLDER/out-mem-debug.txt
rg "([0-9,]*) bytes allocated" -or '$1' -N --color never $ARTIFACTS_FOLDER/out-mem-release.txt

# samply record -s -o "$ARTIFACTS_FOLDER/out-samply.json.gz" ./target/release/example
# echo "Trunk:"

./bin-main

echo "---"

./bin-compact

# echo "Fork:"

# ./bin-fork 2>/dev/null

# ./bin-fork 2>&1 | tail -n 1

# echo "Co"

echo "\`\`\`shell
// Main
$(./bin-main 2>/dev/null)

// Comparison using 'hyperfine'
$(hyperfine -i "bin-main")

// Comparison using 'hyperfine'
$(hyperfine -i "bin-main" "bin-compact")
\`\`\`" >> $GITHUB_STEP_SUMMARY


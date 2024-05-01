echo "<details>
<summary>Main</summary>

\`\`\`
// main
$(./bin-main)
// compact
$(./bin-compact)
// buffered
$(./bin-buffered)
// locked
$(./bin-locked)
\`\`\`
</details>
" >> $GITHUB_STEP_SUMMARY

echo "::debug::Running benchmarks"

echo "\`\`\`shell
// Main
$(./bin-main 2>/dev/null)

// On hyperfone
$(hyperfine -i "./bin-main")

// Comparison
$(hyperfine -i "./bin-main" "./bin-compact" "./bin-buffered" "./bin-locked")
\`\`\`
" >> $GITHUB_STEP_SUMMARY

NO_COLOR=1
export NO_COLOR=1

echo "
With \`NO_COLOR=1\`
\`\`\`shell
// Comparison
$(hyperfine -i "./bin-main" "./bin-compact" "./bin-buffered" "./bin-locked")
\`\`\`" >> $GITHUB_STEP_SUMMARY

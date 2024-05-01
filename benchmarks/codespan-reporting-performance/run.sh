echo "<details>
<summary>Main</summary>

\`\`\`
$(./bin-main)
\`\`\`
</details>
" >> $GITHUB_STEP_SUMMARY

echo "<details>
<summary>Compact</summary>

\`\`\`
$(./bin-compact)
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
$(hyperfine -i "./bin-main" "./bin-compact")
\`\`\`
" >> $GITHUB_STEP_SUMMARY

NO_COLOR=1
export NO_COLOR=1

echo "
With \`NO_COLOR=1\`
\`\`\`shell
// Comparison
$(hyperfine -i "./bin-main" "./bin-compact")
\`\`\`" >> $GITHUB_STEP_SUMMARY


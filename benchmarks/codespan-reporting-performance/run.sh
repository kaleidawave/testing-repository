echo "\`\`\`shell
// main
$(./bin-main)
// compact
$(./bin-compact)
// buffered
$(./bin-buffered)
// buffered2
$(./bin-buffered2)
// locked
$(./bin-locked)

// On hyperfine
$(hyperfine -i "./bin-main")

// Buffered2!!!
$(hyperfine -i "./bin-buffered2")

// Comparison
$(hyperfine -i "./bin-main" "./bin-compact" "./bin-buffered" "./bin-buffered2", "./bin-locked")
\`\`\`
" >> $GITHUB_STEP_SUMMARY

# NO_COLOR=1
# export NO_COLOR=1

# echo "
# With \`NO_COLOR=1\`
# \`\`\`shell
# // Comparison
# $(hyperfine -i "./bin-main" "./bin-compact" "./bin-buffered" "./bin-locked")
# \`\`\`" >> $GITHUB_STEP_SUMMARY

NO_COLOR=1
export NO_COLOR=1

echo "::group::Run tools"

function run_tool {
    OUTPUT="$(eval "$2" 2>&1 | sed $'s/\e\\[[0-9;:]*[a-zA-Z]//g')"
    echo "
    
## $1

<details>
<summary>Output</summary>

\`\`\`ts
$OUTPUT
\`\`\`
</details>
" >> $GITHUB_STEP_SUMMARY
} 

run_tool "Ezno" "./ezno/target/release/ezno check demo.ts --timings"
run_tool "Ezno (no diagnostics printing)" "./ezno/target/release/ezno check demo.ts --count-diagnostics --timings"
run_tool "TSC" "tsc --pretty --noEmit demo.ts"
run_tool "STC" "./stc/target/release/stc test demo.ts"

echo "::endgroup::"

echo "::group::Run benchmarks"

echo "## Benchmark files" >> $GITHUB_STEP_SUMMARY

# Ezno and TSC
echo "\`\`\`
$(hyperfine -i './ezno/target/release/ezno check ./demo.ts' 'tsc --pretty --noEmit demo.ts')
\`\`\`" >> $GITHUB_STEP_SUMMARY

# Ezno, STC and TSC
H1=$(hyperfine -i './ezno/target/release/ezno check ./demo.ts --count-diagnostics' './ezno/target/release/ezno check ./demo.ts' './stc/target/release/stc test demo.ts' 'tsc --pretty --noEmit demo.ts')
echo "with STC
\`\`\`
$H1
\`\`\`" >> $GITHUB_STEP_SUMMARY

for i in {1..5}; do
    cat ./demo.ts >> ./large.ts
done

echo "Given demo.ts with $(wc -l demo.ts) lines & large.ts with $(wc -l large.ts) lines" >> $GITHUB_STEP_SUMMARY

# small (demo.ts) and large.ts
echo "\`\`\`
// demo.ts
$(./ezno/target/release/ezno check ./demo.ts --count-diagnostics --timings)

// large.ts
$(./ezno/target/release/ezno check ./large.ts --count-diagnostics --timings)

// comparison of small vs large (ezno)
$(hyperfine -i './ezno/target/release/ezno check ./demo.ts --count-diagnostics' './ezno/target/release/ezno check ./large.ts --count-diagnostics')

// comparison of small vs large (tsc)
$(hyperfine -i 'tsc --noEmit demo.ts' 'tsc --noEmit large.ts')
\`\`\`" >> $GITHUB_STEP_SUMMARY

# Ezno, STC and TSC
H2=$(hyperfine -i './ezno/target/release/ezno check ./large.ts' './stc/target/release/stc test large.ts' 'tsc --pretty --noEmit large.ts')
echo "Large small etc
\`\`\`
$H2
\`\`\`" >> $GITHUB_STEP_SUMMARY

# Temporary what is going on
# cat $GITHUB_STEP_SUMMARY >> "$ARTIFACTS_FOLDER/out.md"

echo "::endgroup::"

# mkdir -p cached_targets
# mv stc/target cached_targets/stc
# mv ezno/target cached_targets/ezno

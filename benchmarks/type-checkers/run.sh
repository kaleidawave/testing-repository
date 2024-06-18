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

run_tool "Ezno" "./ezno/target/release/ezno check demo.tsx --timings"
run_tool "Ezno (no diagnostics printing)" "./ezno/target/release/ezno check demo.tsx --count-diagnostics --timings"
run_tool "TSC" "tsc --pretty --noEmit --jsx preserve demo.tsx"
run_tool "STC" "./stc/target/release/stc test demo.tsx"

echo "::endgroup::"

echo "::group::Run benchmarks"

echo "## Benchmark files" >> $GITHUB_STEP_SUMMARY

# Ezno and TSC
echo "\`\`\`
$(hyperfine -i './ezno/target/release/ezno check ./demo.tsx' 'tsc --pretty --noEmit --jsx preserve demo.tsx')
\`\`\`" >> $GITHUB_STEP_SUMMARY

# Ezno, STC and TSC
H1=$(hyperfine -i './ezno/target/release/ezno check ./demo.tsx' './stc/target/release/stc test demo.tsx' 'tsc --pretty --noEmit --jsx preserve demo.tsx')

echo "with STC
\`\`\`
$H1
\`\`\`" >> $GITHUB_STEP_SUMMARY

for i in {1..8}; do
    cat ./demo.tsx >> ./large.ts
done

echo "Given demo.tsx with $(wc -l demo.tsx) lines & large.ts with $(wc -l large.ts) lines" >> $GITHUB_STEP_SUMMARY

# small (demo.tsx) and large.ts
echo "\`\`\`
// demo.tsx
$(./ezno/target/release/ezno check ./demo.tsx --max-diagnostics 0 --timings)

// large.ts
$(./ezno/target/release/ezno check ./large.ts --max-diagnostics 0 --timings)

// comparison of small vs large (ezno)
$(hyperfine -i './ezno/target/release/ezno check ./demo.tsx' './ezno/target/release/ezno check ./large.ts')

// comparison of small vs large (tsc)
$(hyperfine -i 'tsc --noEmit demo.tsx' 'tsc --noEmit large.ts')
\`\`\`" >> $GITHUB_STEP_SUMMARY

# Ezno, STC and TSC
H2=$(hyperfine -i './ezno/target/release/ezno check ./large.ts' './stc/target/release/stc test large.ts' 'tsc --pretty --noEmit --jsx preserve large.ts')

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

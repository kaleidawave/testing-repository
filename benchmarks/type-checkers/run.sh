NO_COLOR=1
export NO_COLOR=1

echo $ARTIFACTS_FOLDER
echo $SOMETHING

echo "::group::Run tools"

function run_tool {
    OUTPUT="$(eval "$2" 2>&1 | sed $'s/\e\\[[0-9;:]*[a-zA-Z]//g')"
    echo "## $1

<details>
<summary>Output</summary>

\`\`\`
$OUTPUT
\`\`\`
</details>

" >> $GITHUB_STEP_SUMMARY
} 

run_tool "Ezno" "./ezno/target/release/ezno check demo.tsx --timings"
run_tool "Ezno (next)" "./ezno-next/target/release/ezno check demo.tsx --timings"
# run_tool "Ezno (no diagnostics printing)" "./ezno/target/release/ezno check demo.tsx --max-diagnostics 0 --timings"
run_tool "TSC" "tsc --pretty --noEmit --noLibCheck --jsx preserve --diagnostics demo.tsx"
# run_tool "STC" "./stc/target/release/stc test demo.tsx"

echo "::endgroup::"

# echo "::group::Run benchmarks"

# echo "## Benchmark files" >> $GITHUB_STEP_SUMMARY

# Ezno and TSC
# echo "\`\`\`
# $(hyperfine -i './ezno/target/release/ezno check ./demo.tsx' 'tsc --pretty --noEmit --jsx preserve demo.tsx')
# \`\`\`" >> $GITHUB_STEP_SUMMARY

# # Ezno, STC and TSC
# H1=$(hyperfine -i './ezno/target/release/ezno check ./demo.tsx' './stc/target/release/stc test demo.tsx' 'tsc --pretty --noEmit --jsx preserve demo.tsx')

# echo "with STC
# \`\`\`
# $H1
# \`\`\`" >> $GITHUB_STEP_SUMMARY

# echo "Given demo.tsx with $(wc -l < demo.tsx) lines & large.tsx with $(wc -l < large.tsx) lines" >> $GITHUB_STEP_SUMMARY

# echo "# simple.tsx
# $(./ezno/target/release/ezno check ./simple.tsx --max-diagnostics 0 --timings)

# # demo.tsx
# $(./ezno/target/release/ezno check ./demo.tsx --max-diagnostics 0 --timings)

# # large.tsx
# $(./ezno/target/release/ezno check ./large.tsx --max-diagnostics 0 --timings)

# # comparison of small vs large (ezno)
# $(hyperfine -i './ezno/target/release/ezno check ./simple.tsx' './ezno/target/release/ezno check ./demo.tsx' './ezno/target/release/ezno check ./large.tsx')" > "$ARTIFACTS_FOLDER/ezno-diff.txt"

# echo "# simple.tsx
# $(tsc --pretty --diagnostics --noEmit --noLib --jsx preserve ./simple.tsx overrides.d.ts)

# # demo.tsx
# $(tsc --pretty --diagnostics --noEmit --noLib --jsx preserve ./demo.tsx overrides.d.ts)

# # large.tsx
# $(tsc --pretty --diagnostics --noEmit --noLib --jsx preserve ./large.tsx overrides.d.ts)

# # comparison of simple vs small vs large (tsc)
# $(hyperfine -i 'tsc --noEmit --noLib --pretty --jsx preserve simple.tsx overrides.d.ts' 'tsc --noEmit --noLib --pretty --jsx preserve demo.tsx overrides.d.ts' 'tsc --noEmit --noLib --pretty --jsx preserve large.tsx overrides.d.ts')" > "$ARTIFACTS_FOLDER/tsc-diff.txt"

# # Ezno, STC and TSC on large
# H2=$(hyperfine -i './ezno/target/release/ezno check ./large.tsx' './stc/target/release/stc test large.tsx' 'tsc --pretty --noEmit --noLib --jsx preserve large.tsx overrides.d.ts')

# echo "On large
# \`\`\`
# $H2
# \`\`\`" >> $GITHUB_STEP_SUMMARY

# echo "::endgroup::"

# echo "::group::Each"
# for f in "./all"
# do
# if [[ "$f" != *\.* ]]
# then
#   echo "Item: $f" >> all.txt
#   ./ezno/target/release/ezno check $f --max-diagnostics 0 --timings >> all.txt
# fi
# done

# cp ./all.txt $ARTIFACTS_FOLDER

# ls $ARTIFACTS_FOLDER

# echo "::endgroup::"

# Temporary what is going on
# cat $GITHUB_STEP_SUMMARY >> "$ARTIFACTS_FOLDER/out.md"
# mkdir -p cached_targets
# mv stc/target cached_targets/stc
# mv ezno/target cached_targets/ezno

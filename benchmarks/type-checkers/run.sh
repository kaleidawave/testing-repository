NO_COLOR=1
export NO_COLOR=1

echo $ARTIFACTS_FOLDER
echo $SOMETHING

echo "::group::Run tools"

function run_tool {
    OUTPUT="$(eval "$2" 2>&1 | sed $'s/\e\\[[0-9;:]*[a-zA-Z]//g')"
    echo "## $1

<details>
<summary>Output of `$2`</summary>

\`\`\`
$OUTPUT
\`\`\`
</details>

" >> $GITHUB_STEP_SUMMARY
} 

run_tool "Ezno" "./ezno/target/release/ezno check demo.tsx --timings"
run_tool "TSC" "./tsc-go/built/local/tsgo --pretty --noEmit --skipLibCheck --jsx preserve --diagnostics demo.tsx"

echo "::endgroup::"

# ---

echo "::group::Run benchmarks"

echo "## Benchmark files" >> $GITHUB_STEP_SUMMARY

# Ezno and TSC
echo "##### `demo.tsx`

\`\`\`
$(hyperfine -i \
  './ezno/target/release/ezno check ./demo.tsx' \
  './tsc-go/built/local/tsgo --skipLibCheck ./demo.tsx' \
  'tsc --pretty --skipLibCheck --noEmit --jsx preserve ./demo.tsx' \
)
\`\`\`

##### `large.tsx`

\`\`\`
$(hyperfine -i \
  './ezno/target/release/ezno check ./large.tsx' \
  './tsc-go/built/local/tsgo --skipLibCheck ./large.tsx' \
  'tsc --pretty --skipLibCheck --noEmit --jsx preserve ./large.tsx' \
)
\`\`\`

### Valgrind

ezno
\`\`\`
$(valgrind ./ezno/target/release/ezno check ./demo.tsx)
\`\`\`

tsc
\`\`\`
$(valgrind tsc --pretty --skipLibCheck --noEmit --jsx preserve ./demo.tsx)
\`\`\`

tsc-go
\`\`\`
$(valgrind ./tsc-go/built/local/tsgo --skipLibCheck ./demo.tsx)
\`\`\`

" >> $GITHUB_STEP_SUMMARY

echo "::endgroup::"
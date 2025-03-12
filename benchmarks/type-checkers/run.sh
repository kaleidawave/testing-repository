NO_COLOR=1
export NO_COLOR=1

ls

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
run_tool "TSC" "./tsc-go/built/local/tsgo tsc -pretty -noEmit -skipLibCheck demo.tsx"

echo "::endgroup::"

# ---

echo "::group::Run benchmarks"

echo "## Benchmark files" >> $GITHUB_STEP_SUMMARY

./tsc-go/built/local/tsgo --help
./tsc-go/built/local/tsgo tsc --help

hyperfine -i \
  './ezno/target/release/ezno check ./demo.tsx' \
  './tsc-go/built/local/tsgo tsc -skipLibCheck ./demo.tsx' \
  'tsc --pretty --skipLibCheck --noEmit --jsx preserve ./demo.tsx'

hyperfine -i \
  './ezno/target/release/ezno check ./large.tsx' \
  './tsc-go/built/local/tsgo tsc -skipLibCheck ./large.tsx' \
  'tsc --pretty --skipLibCheck --noEmit --jsx preserve ./large.tsx'

# Ezno and TSC
echo "##### `demo.tsx`

\`\`\`
$(hyperfine -i \
  './ezno/target/release/ezno check ./demo.tsx' \
  './tsc-go/built/local/tsgo tsc -skipLibCheck ./demo.tsx' \
  'tsc --pretty --skipLibCheck --noEmit --jsx preserve ./demo.tsx' \
)
\`\`\`

##### `large.tsx`

\`\`\`
$(hyperfine -i \
  './ezno/target/release/ezno check ./large.tsx' \
  './tsc-go/built/local/tsgo tsc -skipLibCheck ./large.tsx' \
  'tsc --pretty --skipLibCheck --noEmit --jsx preserve ./large.tsx' \
)
\`\`\`
" >> $GITHUB_STEP_SUMMARY

### Valgrind
valgrind --log-file="ezno.txt" ./ezno/target/release/ezno check ./demo.tsx
valgrind --log-file="tsc-go.txt" ./tsc-go/built/local/tsgo tsc -skipLibCheck ./demo.tsx
valgrind --log-file="tsc.txt" tsc --pretty --skipLibCheck --noEmit --jsx preserve ./demo.tsx

echo "ezno
\`\`\`
$(cat ezno.txt)
\`\`\`

tsc-go
\`\`\`
$(cat tsc-go.txt)
\`\`\`

tsc
\`\`\`
$(cat tsc.txt)
\`\`\`
" >> $GITHUB_STEP_SUMMARY

echo "::endgroup::"
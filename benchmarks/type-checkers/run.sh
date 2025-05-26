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

run_tool "Ezno" "./ezno/target/release/ezno check demo.ts --max-diagnostics 0 --timings"
run_tool "TSC" "./node_modules/.bin/tsgo -pretty -noEmit -skipLibCheck -diagnostics demo.ts"

echo "::endgroup::"

# ---

echo "::group::Run benchmarks"

echo "## Benchmark files" >> $GITHUB_STEP_SUMMARY

./node_modules/.bin/tsgo --help

hyperfine -i \
  './ezno/target/release/ezno check ./demo.ts' \
  './node_modules/.bin/tsgo -skipLibCheck ./demo.ts' \
  'tsc --pretty --skipLibCheck --noEmit --jsx preserve ./demo.ts'

hyperfine -i \
  './ezno/target/release/ezno check ./large.ts' \
  './node_modules/.bin/tsgo -skipLibCheck ./large.ts' \
  'tsc --pretty --skipLibCheck --noEmit --jsx preserve ./large.ts'

# Ezno and TSC
echo "##### `demo.ts`

\`\`\`
$(hyperfine -i \
  './ezno/target/release/ezno check ./demo.ts' \
  './node_modules/.bin/tsgo -skipLibCheck ./demo.ts' \
  'tsc --pretty --skipLibCheck --noEmit --jsx preserve ./demo.ts'
)
\`\`\`

##### `large.ts`

\`\`\`
$(hyperfine -i \
  './ezno/target/release/ezno check ./large.ts' \
  './node_modules/.bin/tsgo -skipLibCheck ./large.ts' \
  'tsc --pretty --skipLibCheck --noEmit --jsx preserve ./large.ts'
)
\`\`\`
" >> $GITHUB_STEP_SUMMARY

### Valgrind
valgrind --log-file="ezno.txt" ./ezno/target/release/ezno check ./demo.ts
# valgrind --log-file="tsc-go.txt" ./node_modules/.bin/tsgo -skipLibCheck ./demo.ts
# valgrind --log-file="tsc.txt" tsc --pretty --skipLibCheck --noEmit --jsx preserve ./demo.ts

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
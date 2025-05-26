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
run_tool "TSC" "./node_modules/@typescript/native-preview-linux-x64/lib/tsgo -pretty -noEmit -skipLibCheck -diagnostics demo.ts"

echo "::endgroup::"

# ---

echo "::group::Run benchmarks"

echo "## Benchmark files" >> $GITHUB_STEP_SUMMARY

./node_modules/@typescript/native-preview-linux-x64/lib/tsgo --help

hyperfine -i \
  './ezno/target/release/ezno check ./demo.ts' \
  './node_modules/@typescript/native-preview-linux-x64/lib/tsgo -skipLibCheck ./demo.ts' \
  'tsc --pretty --skipLibCheck --noEmit --jsx preserve ./demo.ts'

hyperfine -i \
  './ezno/target/release/ezno check ./large.ts' \
  './node_modules/@typescript/native-preview-linux-x64/lib/tsgo -skipLibCheck ./large.ts' \
  'tsc --pretty --skipLibCheck --noEmit --jsx preserve ./large.ts'

# Ezno and TSC
echo "##### `demo.ts`

\`\`\`
$(hyperfine -i \
  './ezno/target/release/ezno check ./demo.ts' \
  './node_modules/@typescript/native-preview-linux-x64/lib/tsgo -skipLibCheck ./demo.ts' \
  'tsc --pretty --skipLibCheck --noEmit --jsx preserve ./demo.ts'
)
\`\`\`

##### `large.ts`

\`\`\`
$(hyperfine -i \
  './ezno/target/release/ezno check ./large.ts' \
  './node_modules/@typescript/native-preview-linux-x64/lib/tsgo -skipLibCheck ./large.ts' \
  'tsc --pretty --skipLibCheck --noEmit --jsx preserve ./large.ts'
)
\`\`\`
" >> $GITHUB_STEP_SUMMARY

### Valgrind
valgrind --log-file="ezno.txt" ./ezno/target/release/ezno check ./demo.ts

echo "::group::Callgrind"
{
  valgrind --tool=callgrind --callgrind-out-file=./cpu-out ./ezno/target/release/ezno check ./demo.ts
} || true
# echo "::notice::CPU usage:$(rg "summary: (.*)" -or '$1' -N --color never cpu_out)"
cat cpu_out
echo "::endgroup::"
# valgrind --log-file="tsc-go.txt" ./node_modules/@typescript/native-preview-linux-x64/lib/tsgo -skipLibCheck ./demo.ts
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
echo "tsc 6 demo with node"
node ./node_modules/typescript5/lib/_tsc.js --noEmit --jsx preserve --skipLibCheck --diagnostics demo.tsx || true

# echo "tsc 6 demo10 with node"
# node ./node_modules/typescript5/lib/_tsc.js --noEmit --jsx preserve --skipLibCheck --diagnostics demo10.tsx || true

echo "tsc 7+ (native) demo"
./node_modules/@typescript/typescript-linux-x64/lib/tsc --noEmit --jsx preserve --skipLibCheck --diagnostics demo.tsx || true

# echo "tsc 7+ (native) demo10"
# ./node_modules/@typescript/typescript-linux-x64/lib/tsc --noEmit --jsx preserve --skipLibCheck --diagnostics demo10.tsx || true

echo "ezno demo"
./ezno check demo.tsx --timings || true

echo "ezno demo10"
./ezno check demo10.tsx --timings || true

echo "bun check demo"
bun check --timing demo.tsx || true

# echo "bun check demo10"
# bun check --noEmit --jsx preserve --skipLibCheck --diagnostics demo10.tsx || true

echo "tsc-rs demo"
./node_modules/@tsc-rs/linux-x64/lib/tsc --noEmit --jsx preserve --skipLibCheck --diagnostics demo.tsx || true

# echo "tsc-rs demo10"
# ./node_modules/@tsc-rs/linux-x64/lib/tsc --noEmit --jsx preserve --skipLibCheck --diagnostics demo10.tsx || true

echo "tsrs demo"
./node_modules/@maschwenk/tsrs-linux-x64/tsrs --noEmit --jsx preserve --skipLibCheck --diagnostics demo.tsx || true

# echo "tsrs demo10"
# ./node_modules/@maschwenk/tsrs-linux-x64/tsrs --noEmit --jsx preserve --skipLibCheck --diagnostics demo10.tsx || true

# echo "tsz demo"
# tsz --noEmit --jsx preserve --skipLibCheck --diagnostics demo.tsx || true

# echo "tsz demo10"
# tsz --noEmit --jsx preserve --skipLibCheck --diagnostics demo10.tsx || true

# ---

echo "### Comparison with demo.tsx" >> "$GITHUB_STEP_SUMMARY"
echo "" >> "$GITHUB_STEP_SUMMARY"

echo "\`\`\`shell" >> "$GITHUB_STEP_SUMMARY"
hyperfine -N -i --export-markdown="$GITHUB_STEP_SUMMARY" \
	'node ./node_modules/typescript5/lib/_tsc.js --noEmit --jsx preserve --skipLibCheck demo.tsx' \
	'./node_modules/@typescript/typescript-linux-x64/lib/tsc --noEmit --jsx preserve --skipLibCheck demo.tsx' \
	'./ezno check demo.tsx' \
	'bun check demo.tsx' \
	'./node_modules/@tsc-rs/linux-x64/lib/tsc --noEmit --jsx preserve --skipLibCheck demo.tsx' \
	'./node_modules/@maschwenk/tsrs-linux-x64/tsrs --noEmit --jsx preserve --skipLibCheck demo.tsx'
	# 'tsz --noEmit --jsx preserve --skipLibCheck demo.tsx' \
echo "\`\`\`" >> "$GITHUB_STEP_SUMMARY"

echo "" >> "$GITHUB_STEP_SUMMARY"
echo "### Comparison with demo10.tsx" >> "$GITHUB_STEP_SUMMARY"
echo "" >> "$GITHUB_STEP_SUMMARY"

echo "\`\`\`shell" >> "$GITHUB_STEP_SUMMARY"
hyperfine -N -i --export-markdown="$GITHUB_STEP_SUMMARY" \
	'node ./node_modules/typescript5/lib/_tsc.js --noEmit --jsx preserve --skipLibCheck demo10.tsx' \
	'./node_modules/@typescript/typescript-linux-x64/lib/tsc --noEmit --jsx preserve --skipLibCheck demo10.tsx' \
	'./ezno check demo10.tsx' \
	'bun check demo10.tsx' \
	'./node_modules/@tsc-rs/linux-x64/lib/tsc --noEmit --jsx preserve --skipLibCheck demo10.tsx' \
	'./node_modules/@maschwenk/tsrs-linux-x64/tsrs --noEmit --jsx preserve --skipLibCheck demo10.tsx'
	# 'tsz --noEmit --jsx preserve --skipLibCheck demo10.tsx' \
echo "\`\`\`" >> "$GITHUB_STEP_SUMMARY"

# cat benchmarks/ts-type-checkers/notes.md >> "$GITHUB_STEP_SUMMARY"

# TODO post to val.town

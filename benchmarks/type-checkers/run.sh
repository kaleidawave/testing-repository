# TODO temp, for some reason bun does not get carried over?
source /home/runner/.bash_profile
# bun check --help

echo "tsc 6 demo with node"
node ./node_modules/typescript5/lib/_tsc.js --noEmit --jsx preserve --skipLibCheck --diagnostics demo.tsx || true

# -- Commented out some of the below because they show lots of diagnostics

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
./node_modules/@tsrs/linux-x64-gnu/tsrs --noEmit --jsx preserve --skipLibCheck --diagnostics demo.tsx || true

# echo "tsrs demo10"
# ./node_modules/@maschwenk/tsrs-linux-x64/tsrs --noEmit --jsx preserve --skipLibCheck --diagnostics demo10.tsx || true

# echo "tsz demo"
# tsz --noEmit --jsx preserve --skipLibCheck --diagnostics demo.tsx || true

# echo "tsz demo10"
# tsz --noEmit --jsx preserve --skipLibCheck --diagnostics demo10.tsx || true

# ---

echo "### Comparison with \`check demo.tsx\`" >> "$GITHUB_STEP_SUMMARY"
echo "" >> "$GITHUB_STEP_SUMMARY"

hyperfine -N -i --export-markdown=out.md \
	'node ./node_modules/typescript5/lib/_tsc.js --noEmit --jsx preserve --skipLibCheck demo.tsx' \
	'./node_modules/@typescript/typescript-linux-x64/lib/tsc --noEmit --jsx preserve --skipLibCheck demo.tsx' \
	'./ezno check demo.tsx' \
	'bun check demo.tsx' \
	'./node_modules/@tsc-rs/linux-x64/lib/tsc --noEmit --jsx preserve --skipLibCheck demo.tsx' \
	'./node_modules/@tsrs/linux-x64-gnu/tsrs --noEmit --jsx preserve --skipLibCheck demo.tsx'
	# 'tsz --noEmit --jsx preserve --skipLibCheck demo.tsx' \

cat out.md >> "$GITHUB_STEP_SUMMARY"

echo "### Comparison with \`check demo10.tsx\`" >> "$GITHUB_STEP_SUMMARY"
echo "" >> "$GITHUB_STEP_SUMMARY"

hyperfine -N -i --export-markdown=out.md \
	'node ./node_modules/typescript5/lib/_tsc.js --noEmit --jsx preserve --skipLibCheck demo10.tsx' \
	'./node_modules/@typescript/typescript-linux-x64/lib/tsc --noEmit --jsx preserve --skipLibCheck demo10.tsx' \
	'./ezno check demo10.tsx' \
	'bun check demo10.tsx' \
	'./node_modules/@tsc-rs/linux-x64/lib/tsc --noEmit --jsx preserve --skipLibCheck demo10.tsx' \
	'./node_modules/@tsrs/linux-x64-gnu/tsrs --noEmit --jsx preserve --skipLibCheck demo10.tsx'
	# 'tsz --noEmit --jsx preserve --skipLibCheck demo10.tsx' \

cat out.md >> "$GITHUB_STEP_SUMMARY"
echo "" >> "$GITHUB_STEP_SUMMARY"

# TODO post to somewhere longer lasting

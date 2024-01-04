# Install hyperfine
brew install hyperfine

echo "::group::Get tools"

[ -f cached_targets ] && ls cached_targets

echo "::group::Build Ezno"
rustc --version

git clone https://github.com/kaleidawave/ezno ezno
[ -f cached_targets/ezno ] && mv cached_targets/ezno ezno/target
cargo build --release --manifest-path ezno/Cargo.toml

./ezno/target/release/ezno --help

echo "::group::Build demo.ts"
cat ./ezno/checker/specification/specification.md

cargo run --manifest-path ezno/Cargo.toml -p ezno-parser --example code_blocks_to_script ./ezno/checker/specification/specification.md ./demo.ts

echo "<details>
    <summary>Input</summary>
    \`\`\`ts
    " >> $GITHUB_STEP_SUMMARY
cat ./demo.ts >> $GITHUB_STEP_SUMMARY
echo "\`\`\`

</details>
" >> $GITHUB_STEP_SUMMARY

echo "::endgroup::"

echo "::endgroup::"

# npm install -g oxidation-compiler@latest

echo "::group::Build STC"
git clone https://github.com/dudykr/stc stc
cd stc
git reset --hard 693cf5a891c5580542811b906616f0c15d0dd0fc
cd ..
[ -f cached_targets/stc ] && mv cached_targets/stc stc/target

rustup toolchain install nightly
cargo +nightly build --release --manifest-path stc/crates/stc/Cargo.toml

./target/release/stc --help
echo "::endgroup::"

npm install -g typescript

echo "::endgroup"

NO_COLOR=1
echo "::group::Run tools"

function run_tool {
    echo "## $1" >> $GITHUB_STEP_SUMMARY
    echo "\`\`\`shell" >> $GITHUB_STEP_SUMMARY
    OUTPUT="$(eval "$2" 2>&1 | sed $'s/\e\\[[0-9;:]*[a-zA-Z]//g')"
    echo "$OUTPUT" >> $GITHUB_STEP_SUMMARY
    echo "\`\`\`" >> $GITHUB_STEP_SUMMARY
} 

run_tool "Ezno" "./ezno/target/release/ezno check demo.ts --timings"
run_tool "TSC" "tsc --pretty --noEmit demo.ts"
run_tool "STC" "./stc/target/release/stc test demo.ts"

echo "::endgroup::"

# Run benchmark
echo "::group::Run benchmarks"

echo "## Hyperfine" >> $GITHUB_STEP_SUMMARY

# Ezno and TSC
echo "\`\`\`shell">> $GITHUB_STEP_SUMMARY
hyperfine -i '.ezno/target/release/ezno check ./demo.ts' 'tsc --pretty --noEmit demo.ts' >> $GITHUB_STEP_SUMMARY
echo "\`\`\`" >> $GITHUB_STEP_SUMMARY

# Ezno, STC and TSC
echo "\`\`\`shell">> $GITHUB_STEP_SUMMARY
hyperfine -i '.ezno/target/release/ezno check ./demo.ts' './stc/target/release/stc test demo.ts' 'tsc --pretty --noEmit demo.ts' >> $GITHUB_STEP_SUMMARY
echo "\`\`\`" >> $GITHUB_STEP_SUMMARY

echo "::endgroup::"

mkdir -p cached_targets
mv stc/target cached_targets/stc
mv ezno/target cached_targets/ezno

# Install hyperfine
brew install hyperfine

echo "::group::Get tools"

# [ -f cached_targets ] && ls cached_targets

echo "::group::Build Ezno"
rustc --version
rustup toolchain install stable
# rustup toolchain install 1.75.0

# [ -f cached_targets/ezno ] && mv cached_targets/ezno ezno/target

# mkdir -p ./ezno2/target/release
# gh release download -R kaleidawave/ezno -p "*.exe" -O ezno
# mv ezno ./ezno2/target/release
# mv ezno2 ezno
# ls ezno


git clone https://github.com/kaleidawave/ezno ezno

cargo build --release --manifest-path ezno/Cargo.toml

./ezno/target/release/ezno info

echo "::group::Build demo.ts"
cargo run --manifest-path ezno/Cargo.toml -p ezno-parser --example code_blocks_to_script ./ezno/checker/specification/specification.md ./demo.ts

echo "<details>
<summary>Input</summary>

\`\`\`ts
$(cat ./demo.ts)
\`\`\`

</details>" >> $GITHUB_STEP_SUMMARY

echo "::endgroup::"

echo "::endgroup::"

# npm install -g oxidation-compiler@latest

echo "::group::Build STC"
git clone https://github.com/dudykr/stc stc
cd stc
git reset --hard 693cf5a891c5580542811b906616f0c15d0dd0fc
cd ..
[ -f cached_targets/stc ] && mv cached_targets/stc stc/target

rustup toolchain install nightly-2023-06-20
cargo +nightly-2023-06-20 build --release --manifest-path stc/crates/stc/Cargo.toml

./stc/target/release/stc --help
echo "::endgroup::"

echo "::group::Get TSC"
npm install -g typescript
echo "::endgroup"

echo "::endgroup"

NO_COLOR=1
export NO_COLOR=1

echo "::group::Run tools"

function run_tool {
    OUTPUT="$(eval "$2" 2>&1 | sed $'s/\e\\[[0-9;:]*[a-zA-Z]//g')"
    echo "## $1

<details>
<summary>Output</summary>

\`\`\`ts
$OUTPUT
\`\`\

</details>" >> $GITHUB_STEP_SUMMARY
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
// comparison (ezno)
$(hyperfine -i './ezno/target/release/ezno check ./demo.ts --count-diagnostics' './ezno/target/release/ezno check ./large.ts --count-diagnostics')
// comparison (tsc)
$(hyperfine -i 'tsc --noEmit demo.ts' 'tsc --noEmit large.ts')
\`\`\`" >> $GITHUB_STEP_SUMMARY

# Ezno, STC and TSC
H2=$(hyperfine -i './ezno/target/release/ezno check ./large.ts --count-diagnostics' './ezno/target/release/ezno check ./large.ts' './stc/target/release/stc test large.ts' 'tsc --pretty --noEmit large.ts')
echo "Large small etc
\`\`\`
$H2
\`\`\`" >> $GITHUB_STEP_SUMMARY

echo "::endgroup::"

# mkdir -p cached_targets
# mv stc/target cached_targets/stc
# mv ezno/target cached_targets/ezno

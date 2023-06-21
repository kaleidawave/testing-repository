# Install hyperfine
brew install hyperfine

# Setup tools
echo "::group::Build STC"
git clone https://github.com/dudykr/stc stc
rustup toolchain install nightly
cargo +nightly build --release --manifest-path stc/crates/stc/Cargo.toml

./stc/target/release/stc --help
echo "::endgroup::"

npm install -g oxidation-compiler@latest
npm install -g typescript

# Get demo.ts
echo "::group::Get demo.ts"
curl https://gist.githubusercontent.com/kaleidawave/5dcb9ec03deef1161ebf0c9d6e4b88d8/raw/26c26e908a7c6b79a2e93627f1fefa7ffccbd389/demo.ts > demo.ts
echo "::endgroup::"

echo "::group::Run tools"
function run_tool {
    echo "## $1" >> $GITHUB_STEP_SUMMARY
    echo "\`\`\`shell" >> $GITHUB_STEP_SUMMARY
    OUTUT="$(eval "$2" 2>&1 | sed $'s/\e\\[[0-9;:]*[a-zA-Z]//g')"
    echo $OUTUT >> $GITHUB_STEP_SUMMARY
    echo "\`\`\`" >> $GITHUB_STEP_SUMMARY
} 

run_tool "Ezno checker with Oxc" "oxidation-compiler check demo.ts "
run_tool "TSC" "tsc --pretty demo.ts"
run_tool "STC" "./stc/target/release/stc test demo.ts"
echo "::endgroup::"

# Run benchmark
echo "## Hyperfine" >> $GITHUB_STEP_SUMMARY

echo "\`\`\`shell">> $GITHUB_STEP_SUMMARY
hyperfine -i 'oxidation-compiler check ./demo.ts' 'tsc --pretty demo.ts' >> $GITHUB_STEP_SUMMARY
echo "\`\`\`\n\`\`\`shell">> $GITHUB_STEP_SUMMARY
hyperfine -i './stc/target/release/stc test demo.ts' 'tsc --pretty demo.ts' >> $GITHUB_STEP_SUMMARY
echo "\`\`\`\n\`\`\`shell">> $GITHUB_STEP_SUMMARY
hyperfine -i 'oxidation-compiler check ./demo.ts' './stc/target/release/stc test demo.ts' 'tsc --pretty demo.ts' >> $GITHUB_STEP_SUMMARY
echo "\`\`\`">> $GITHUB_STEP_SUMMARY

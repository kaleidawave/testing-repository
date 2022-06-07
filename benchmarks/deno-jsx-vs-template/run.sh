# Installation
brew install hyperfine
brew install deno

deno bench --unstable .\jsx-vs-template.tsx -A --no-check > "$ARTIFACTS_FOLDER/deno-bench.output.1.txt"
sleep 10
deno bench --unstable .\jsx-vs-template.tsx -A --no-check > "$ARTIFACTS_FOLDER/deno-bench.output.2.txt"
sleep 10
deno bench --unstable .\jsx-vs-template.tsx -A --no-check > "$ARTIFACTS_FOLDER/deno-bench.output.3.txt"
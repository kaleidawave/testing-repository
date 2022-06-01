# Installation
brew install wrk
brew install deno

mkdir $ARTIFACTS_FOLDER/wrk

deno run --allow-net index.ts & 

# Wait for server to start up
sleep 20

# Run benchmark 3x
wrk -t12 -c200 -d30s http://127.0.0.1:3000 > "$ARTIFACTS_FOLDER/wrk/output.1.txt"
sleep 10
wrk -t12 -c200 -d30s http://127.0.0.1:3000 > "$ARTIFACTS_FOLDER/wrk/output.2.txt"
sleep 10
wrk -t12 -c200 -d30s http://127.0.0.1:3000 > "$ARTIFACTS_FOLDER/wrk/output.3.txt"

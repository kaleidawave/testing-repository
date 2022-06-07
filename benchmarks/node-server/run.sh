# Installation (node already exists)
brew install wrk

node index.js & 

# Wait for server to start up
sleep 10

# Run benchmark 3x
wrk -t12 -c200 -d30s http://127.0.0.1:3000 > "$ARTIFACTS_FOLDER/wrk.output.1.txt"
sleep 10
wrk -t12 -c200 -d30s http://127.0.0.1:3000 > "$ARTIFACTS_FOLDER/wrk.output.2.txt"
sleep 10
wrk -t12 -c200 -d30s http://127.0.0.1:3000 > "$ARTIFACTS_FOLDER/wrk.output.3.txt"

curl -v http://127.0.0.1:3000/ > "$ARTIFACTS_FOLDER/wrk.curl.txt"
curl -v http://127.0.0.1:3000/counter.json > "$ARTIFACTS_FOLDER/wrk.curl-counter.txt"

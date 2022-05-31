brew install wrk

cargo build --timings=html

mv target/cargo-timings/* artifacts

./target/debug/rocket-bench &

# pause for server to startup
sleep 5

wrk -t12 -c200 -d30s http://127.0.0.1:3000

wrk -t12 -c200 -d30s http://127.0.0.1:3000 > artifacts/wrk.output.txt
brew install wrk

rustup toolchain install nightly
rustup default nightly

cargo -Z unstable-options build --timings=html

mv target/cargo-timings/* artifacts

path="./target/debug/$(basename $(pwd))"
$path &

# pause for server to startup
sleep 10

wrk -t12 -c200 -d30s http://127.0.0.1:3000 > artifacts/wrk.output.txt
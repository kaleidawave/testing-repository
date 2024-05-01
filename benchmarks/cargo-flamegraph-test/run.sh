echo "::group::First run"
export CARGO_PROFILE_RELEASE_DEBUG=true
cargo flamegraph

ls

echo "::endgroup"

echo "::group::More runs"
cargo flamegraph -o artifacts/one.svg
cargo flamegraph -o artifacts/two.svg
cargo flamegraph --flamechart -o artifacts/three.svg
echo "::endgroup"
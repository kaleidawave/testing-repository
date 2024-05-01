sudo cat /proc/sys/kernel/kptr_restrict
sudo cat /proc/sys/kernel/perf_event_paranoid

echo "::group::First run"
export CARGO_PROFILE_RELEASE_DEBUG=true
cargo flamegraph -c "record -o perf.data -F997 --call-graph dwarf,16384 -g"

echo "<div>
$(cat flamegraph.svg)
</div>" >> $GITHUB_STEP_SUMMARY

echo "::endgroup"

echo "::group::More runs"
cargo flamegraph -c "record -o perf.data -F997 --call-graph dwarf,16384 -g" -o ./artifacts/one.svg
cargo flamegraph -c "record -o perf.data -F997 --call-graph dwarf,16384 -g" -o ./artifacts/two.svg
cargo flamegraph -c "record -o perf.data -F997 --call-graph dwarf,16384 -g" --flamechart -o ./artifacts/three.svg
echo "::endgroup"

ls artifacts
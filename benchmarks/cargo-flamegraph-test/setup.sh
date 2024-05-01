cargo install flamegraph

sudo apt install linux-tools-common linux-tools-generic linux-tools-`uname -r`

# sudo sh -c 'echo 1 >/proc/sys/kernel/perf_event_paranoid'
sudo sysctl -w kernel.perf_event_paranoid=1

cat /proc/sys/kernel/perf_event_paranoid
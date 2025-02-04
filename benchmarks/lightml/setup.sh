# Performance tools
brew install hyperfine
sudo apt-get install valgrind
# curl --proto '=https' --tlsv1.2 -LsSf https://github.com/mstange/samply/releases/download/samply-v0.13.1/samply-installer.sh | sh

# Check they exist
# samply --help
valgrind --help

# Example file
curl https://www.theguardian.com/uk > ./example.html

# Build (debug) binary
cargo build

# Build (release) binary
cargo build --release
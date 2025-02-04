# Performance tools
brew install hyperfine
sudo apt-get install valgrind
# curl --proto '=https' --tlsv1.2 -LsSf https://github.com/mstange/samply/releases/download/samply-v0.13.1/samply-installer.sh | sh

# Utilities
brew install ripgrep

gh release download -R BurntSushi/ripgrep --pattern "*x86*unknown-linux*"
# TODO can we reuse the name here
unzip ripgrep-14.1.1-x86_64-unknown-linux-musl
# echo ripgrep-14.1.1-x86_64-unknown-linux-musl >> "$GITHUB_PATH"
ls -R

# Check they exist
# samply --help
# valgrind --help

# Example file
curl https://www.theguardian.com/uk > ./example.html

# Build (debug) binary
cargo build

# Build (release) binary
cargo build --release
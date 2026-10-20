# CORPUS
curl https://gist.githubusercontent.com/kaleidawave/81066f322ed574b3373e27770137013f/raw/b04dcc0bc60e6331008bdd578b98224cc07d5d42/all.tsx > demo.tsx

touch demo10.tsx

for i in {1..10}; do
	cat demo.tsx >> demo10.tsx
done

# TOOLS

# TYPESCRIPT 5 (JS/NODE)
npm install typescript5@npm:typescript@5
node ./node_modules/typescript5/lib/_tsc.js -v || true

# TYPESCRIPT 6+ (GOLANG)
npm install typescript
./node_modules/@typescript/typescript-linux-x64/lib/tsc -v || true

# EZNO
curl -L https://github.com/kaleidawave/assets/releases/download/assets/ezno-feb-26-x86_64-unknown-linux > ezno
chmod +x ./ezno
./ezno --help || true

# Bun (TODO can install canary be done in one step)
curl -fsSL https://bun.com/install | bash
source /home/runner/.bash_profile
bun upgrade --canary
bun check --help || true

# ts-rust (https://github.com/pingdotgg/ts-rust)
npm install -D tsc-rs
npx tsc-rs -p tsconfig.json
./node_modules/@tsc-rs/linux-x64/lib/tsc --help || true

# tsrs (https://github.com/oxc-project/tsrs)
npm install -D tsrs
./node_modules/@tsrs/linux-x64-gnu/tsrs --help || true

# TODO cannot get to work?
# tsz (https://github.com/tsz-org/tsz)
# curl -fsSL https://tsz.dev/install | sh
# tsz --help || true

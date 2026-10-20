### Notes

This benchmark ran on a GitHub Linux x86 runner.

[`demo.tsx`](https://gist.github.com/kaleidawave/81066f322ed574b3373e27770137013f) is a single file with samples from a cases in the ezno specification. It is **2500** lines. `demo10.tsx` is the file repeated 10 times.

While Ezno is missing a lot (async, generators, etc), it is feature complete with regards to its own specification.

Ezno is not 1:1 with TypeScript, it has [additional capabilities and different type-checking capability](https://kaleidawave.blog/ezno/comparison/) it is built from the ground up. It started in 2021 but has recently (2026) been *on pause*.

TypeScript/tsc 7+ [started in late 2024](https://devblogs.microsoft.com/typescript/typescript-native-port/).

[tsc-rust](https://github.com/pingdotgg/ts-rust), [tsrs](https://github.com/maschwenk/tsrs) and [`bun check`](https://bun.com/docs/runtime/check) are LLM assisted rewrites. Started in 2026.

### Not included

- [oxc_checker](https://github.com/camchenry/oxc_checker): do not know if it is at the stage of being able to check the given cases 
- [tsrs](https://x.com/SidChatterjee/status/2026384939080421665) (yes aparently there are two tsrs projects): unreleased
- [tsz](https://github.com/tsz-org/tsz): could not get to work[^1]
- [some C++ port](https://x.com/jrysana/status/2104921420522270767): unreleased
- [typerunner](https://github.com/marcj/TypeRunner): unsure how to compile
- [stc](https://github.com/dudykr/stc): archived
- [flow](https://flow.org/): may or may not be relevant. plus it has a [recent port](https://medium.com/flow-type/flows-ocaml-to-rust-port-78b95bcf49e9)
- several other private or unknown ones: open PR against this to mention!

Non-checkers

- [Biome type inference](https://arendjr.nl/blog/2025/05/biome-type-architecture/)
- [`simple_ts`](https://github.com/kermanx/simple_ts) (inference)
- [`tyvm`](https://github.com/zackradisic/tyvm) (turned into flappy bird lol)

### Further notes

- TODO see the ezno performance page

[^1]: Could not get tsz to work, recieved

```bash
sh: 6: set: Illegal option -o pipefail
./setup.sh: line 41: tsz: command not found
```

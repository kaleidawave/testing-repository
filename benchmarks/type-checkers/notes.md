### Notes

[`demo.tsx`](https://gist.github.com/kaleidawave/81066f322ed574b3373e27770137013f) is a single file with samples from a cases in the ezno specification. It is **2500** lines. `demo10.tsx` is the file repeated 10 times.

Ezno is not 1:1 with TypeScript, it has [additional capabilities and different type-checking capability](https://kaleidawave.blog/ezno/comparison/) it is built from the ground up. Little has been copied from tsc source code. Started in 2021 but has recently (2026) been *on pause*.

TypeScript/tsc 7+ is written in golang. [Started in late 2025](https://devblogs.microsoft.com/typescript/typescript-native-port/).

[tsc-rust](https://t.co/zZAtML5zvu), [tsrs](https://github.com/maschwenk/tsrs) and [tsz](https://github.com/tsz-org/tsz) are LLM assisted rewrites. Started in 2026.

### Not included

- [oxc_checker](https://github.com/camchenry/oxc_checker): do not believe is at the stage to apply these cases to
- [tsrs](https://x.com/SidChatterjee/status/2026384939080421665) (the other one tsrs): unreleased
- [some C++ port](https://x.com/jrysana/status/2104921420522270767): unreleased
- [typerunner](https://github.com/marcj/TypeRunner): unsure how to compile
- [stc](https://github.com/dudykr/stc): archived
- the other ones?

Non-checkers

- [Biome type inference](https://arendjr.nl/blog/2025/05/biome-type-architecture/)
- [`simple_ts`](https://github.com/kermanx/simple_ts) (inference)
- [`tyvm`](https://github.com/zackradisic/tyvm) (turned into flappy bird lol)

### Further notes

- TODO see the ezno performance page

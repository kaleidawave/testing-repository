import { $ } from "bun";
import { progress } from '@ryweal/progress'

$.nothrow();

class Duration {
  nanos: number

  constructor(nanos: number) {
    this.nanos = nanos
  }

  add(other: Duration) {
    this.nanos += other.nanos;
  }

  divide(by: number) {
    this.nanos /= by;
  }

  static zero() { return new Duration(0) }

  static fromString(str) {
    if (str.at(-1) === "s") {
      str = str.slice(0, -1);
      const modifier = str.at(-1);
      let multiplier = 1e9;
      if (modifier === "m") {
        multiplier = 1e6;
      } else if (modifier === "µ") {
        multiplier = 1e3;
      } else if (modifier === "n") {
        multiplier = 1;
      }
      if (multiplier !== 1e9) {
        str = str.slice(0, -1);
      }

      return new Duration(parseFloat(str) * multiplier)
    } else {
      throw new Error()
    }
  }
}

let e = Duration.zero(), ts = Duration.zero();
const total = 10;
const p = progress('Progress | [[bar]] | [[count]]/[[total]] [[rate]] [[eta]]\n', { total });

for (let i = 0; i < total; i++) {
  p.next();

  {
    const command = $`ezno check ./private/tocheck/all.tsx --max-diagnostics 0 --timings 2>&1`.lines();

    for await (let line of command) {
      if (line.startsWith("Checked")) {
        const [_, time] = line.split("\t");
        e.add(Duration.fromString(time));
      }
    }
  }

  {
    const command = $`tsc ./private/tocheck/all.tsx --noEmit --diagnostics --pretty --skipLibCheck`.lines();

    for await (let line of command) {
      if (line.startsWith("Check time")) {
        const [_, time] = line.split(":");
        ts.add(Duration.fromString(time));
      }
    }
  }
}

console.log(`Ezno ran ${ts.nanos / e.nanos} faster than TSC`);

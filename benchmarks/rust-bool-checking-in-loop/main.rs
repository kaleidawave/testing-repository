use criterion::{criterion_group, criterion_main, Criterion};
use std::fs::read_to_string;

fn count_characters_1(source: &str) -> u64 {
    let mut n = 0;
    for char in source.chars() {
        if char == 'p' {
            n += 1;
        }
    }
    n
}

fn count_characters_2(source: &str) -> (u64, u64) {
    let mut n = 0;
    let mut m = 0;
    for char in source.chars() {
        if n % 2 == 0 {
            m += 5;
        } 
        if char == 'p' {
            n += 1;
        }
    }
    (n, m)
}

pub fn criterion_benchmark(c: &mut Criterion) {
    let data = read_to_string("data.tmp").unwrap().repeat(10);
    c.bench_function("count characters 1", |b| b.iter(|| count_characters_1(&data)));
    c.bench_function("count characters 2", |b| b.iter(|| count_characters_2(&data)));
}

criterion_group!(benches, criterion_benchmark);
criterion_main!(benches);
use criterion::{criterion_group, criterion_main, Criterion};
use std::sync::mpsc::sync_channel;
use std::thread;

struct Smol(pub u64);

struct Larger(pub [u64; 6]);

fn smol() -> u64 {
    let mut n: u64 = 0;
    for idx in 0..100_100 {
        n = n.wrapping_add(55);
    }
    n
}

fn smol_vec() -> u64 {
    let mut items = Vec::with_capacity(100_100);
    for idx in 0..100_100 {
        items.push(Smol(idx));
    }
    let mut n: u64 = 0;
    for item in items {
        n = n.wrapping_add(item.0);
    }
    n
}

fn smol_channel() -> u64 {
    let (sender, receiver) = sync_channel(1000);
    thread::spawn(move|| {
        for idx in 0..100_100 {
            unsafe {
                sender.send(Smol(idx)).unwrap_unchecked();
            }
        }
    });
    let mut n: u64 = 0;
    for item in receiver {
        n = n.wrapping_add(item.0);
    }
    n
}

pub fn criterion_benchmark(c: &mut Criterion) {
    c.bench_function("smol", |b| b.iter(|| smol()));
    c.bench_function("smol_vec", |b| b.iter(|| smol_vec()));
    c.bench_function("smol_channel", |b| b.iter(|| smol_channel()));
}

criterion_group!(benches, criterion_benchmark);
criterion_main!(benches);
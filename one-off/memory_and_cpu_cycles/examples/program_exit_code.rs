use std::hint::black_box;
use std::process::ExitCode;

fn program(_i: i32) {}

fn main() -> ExitCode {
    let args = std::env::args().skip(1).collect::<Vec<_>>();
    let to_allocate: usize = args.first().ok_or("expected memory size").unwrap().parse().unwrap();

    let vec = vec![0u8; to_allocate];

    eprintln!("Allocated {} bytes", vec.len());
    std::hint::black_box(vec);
    ExitCode::FAILURE
}

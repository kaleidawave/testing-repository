use std::process::ExitCode;

fn program(_i: usize) {}

fn main() -> ExitCode {
    let args = std::env::args().skip(1).collect::<Vec<_>>();
    let to_allocate: usize = args
        .first()
        .ok_or("expected memory size")
        .unwrap()
        .parse()
        .unwrap();

    let vec = vec![0u8; to_allocate];

    for i in 0..to_allocate {
        std::hint::black_box(program(i));
    }

    eprintln!("Allocated {} bytes", vec.len());
    std::hint::black_box(vec);
    ExitCode::FAILURE
}

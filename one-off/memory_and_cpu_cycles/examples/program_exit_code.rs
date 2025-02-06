use std::hint::black_box;
use std::process::ExitCode;

fn program(_i: i32) {}

fn main() -> ExitCode {
    for i in 0..10 {
        black_box(program(i));
    }
    black_box(vec![0u8; 1000]);
    ExitCode::FAILURE
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let args = std::env::args().skip(1).collect::<Vec<_>>();
    let to_run: usize = args.first().ok_or("expected run count")?.parse()?;

    std::hint::black_box(run(to_run));

    Ok(())
}

#[inline(never)]
fn run(count: usize) {
    for _ in 0..count {
        call();
    }
}

#[inline(never)]
fn call() {
    eprintln!("Hello World!");
}

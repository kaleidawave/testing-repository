fn main() -> Result<(), Box<dyn std::error::Error>> {
    let args = std::env::args().skip(1).collect::<Vec<_>>();
    let to_run: usize = args.first().ok_or("expected memory size")?.parse()?;

    const THREAD_COUNT: u8 = 4;
    let mut threads = Vec::with_capacity(THREAD_COUNT.into());
    for _ in 0..THREAD_COUNT {
        threads.push(std::thread::spawn(move || {
            std::hint::black_box(run(to_run));
        }));
    }

    for thread in threads {
        thread.join().unwrap();
    }


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
fn main() -> Result<(), Box<dyn std::error::Error>> {
    const THREAD_COUNT: u8 = 4;
    let mut threads = Vec::with_capacity(THREAD_COUNT.into());
    for _ in 0..THREAD_COUNT {
        threads.push(std::thread::spawn(|| {
            let _vec = vec![0u8; 1000];
        }));
    }

    for thread in threads {
        thread.join().unwrap();
    }

    Ok(())
}
fn main() -> Result<(), Box<dyn std::error::Error>> {
    let args = std::env::args().skip(1).collect::<Vec<_>>();
    let to_allocate: usize = args.first().ok_or("expected memory size")?.parse()?;

    let vec = vec![0u8; to_allocate];

    eprintln!("Allocated {} bytes", vec.len());
    std::hint::black_box(vec);

    std::thread::sleep(std::time::Duration::from_secs(1));

    Ok(())
}

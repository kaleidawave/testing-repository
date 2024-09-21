fn main() -> Result<(), Box<dyn std::error::Error>> {
    let array1 = [0u8; 3000];
    eprintln!("Allocated {} bytes", array1.len());
    std::hint::black_box(array1);
    Ok(())
}
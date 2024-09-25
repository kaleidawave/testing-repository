use std::fs;

fn main() -> Result<(), Box<dyn std::error::Error + 'static>> {
    let bytes: Vec<u8> = fs::read("example")?;
    let mut data = [0u32; 4];
    for byte in bytes {
        match byte {
            b'(' => {
                data[0] += 1;
            }
            b')' => {
                data[1] += 1;
            }
            b'<' => {
                data[2] += 1;
            }
            b'>' => {
                data[3] += 1;
            }
            _ => {}
        }
    }

    eprintln!("{:?}", data);
    Ok(())
}
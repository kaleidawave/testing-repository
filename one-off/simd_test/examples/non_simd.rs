use std::fs;

fn main() -> Result<(), Box<dyn std::error::Error + 'static>> {
    let bytes: Vec<u8> = fs::read("example")?;
    let mut data = [0u32; 8];
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
            b'a' => {
                data[4] += 1;
            }
            b'b' => {
                data[5] += 1;
            }
            b'c' => {
                data[6] += 1;
            }
            b'd' => {
                data[7] += 1;
            }
            _ => {}
        }
    }

    eprintln!("{:?}", data);
    Ok(())
}
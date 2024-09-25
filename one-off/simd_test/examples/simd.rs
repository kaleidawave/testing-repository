#![feature(portable_simd)]
use std::simd::{u8x4, cmp::SimdPartialEq};
use std::fs;

fn main() -> Result<(), Box<dyn std::error::Error + 'static>> {
    let bytes: Vec<u8> = fs::read("example")?;
    let mut data = [0u32; 4];
    let a = u8x4::from_slice(b"()<>");
    for byte in bytes {
        let chr_simd = u8x4::splat(byte);
        let result = a.simd_eq(chr_simd);
        if let Some(idx) = result.first_set() {
            data[idx] += 1;
        }
    }

    eprintln!("{:?}", data);
    Ok(())
}
fn main() {
    let x = Box::new([0i32; 1000]);
    std::hint::black_box(Box::leak(x));
}
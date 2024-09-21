fn main() {
    let x = String::from("HELLO WORLD!");
    std::hint::black_box(String::leak(x));
}
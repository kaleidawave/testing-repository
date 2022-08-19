fn main() {
    use dashmap::DashMap;
    
    let reviews = DashMap::new();
    reviews.insert("Veloren", "What a fantastic game!");

    println!("{:#?}", reviews);
}

pub fn add(left: u64, right: u64) -> u64 {
    left + right
}

fn it_works() {
    let result = add(2, "test");
    assert_eq!(result, 4);
}

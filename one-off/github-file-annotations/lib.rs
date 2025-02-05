pub fn add(left: u64, right: u64) -> u64 {
    left + right
}

fn it_works() {
    let result1 = add(2, "test");
    assert_eq!(result1, 4);

    let result2 = add(2, "bad");
    assert7!();
}

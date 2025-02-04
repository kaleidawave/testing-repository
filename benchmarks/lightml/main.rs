fn main() {
    let content = std::fs::read_to_string("./example.html").unwrap();
    let result = lightml::retrieve(
        content.into(),
        "all [data-link-name*='news']\0attribute aria-label".into(),
    );
    eprintln!("{:?}", result.split('\0').next());
}

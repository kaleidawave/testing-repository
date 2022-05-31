use rocket::{Config, routes};

fn main() {
    let config = Config {
        port: 3000,
        ..Config::debug_default()
    };

    rocket::custom(&config).mount("/", routes![hello]).launch();
}

#[get("/")]
fn hello() -> &'static str {
    "Hello World"
}
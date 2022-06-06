use rocket::{
    fairing::{Fairing, Info, Kind},
    get, launch, routes,
    serde::{json::Json, Serialize},
    Config, Data, Request, State,
};
use std::sync::atomic::AtomicUsize;

#[derive(Serialize, Default)]
#[serde(crate = "rocket::serde")]
struct AppContext {
    pub counter: AtomicUsize,
}

#[launch]
fn rocket() -> _ {
    let config = Config {
        port: 3000,
        ..Config::debug_default()
    };

    rocket::custom(&config)
        .attach(CounterFairing)
        .manage(AppContext::default())
        .mount("/", routes![hello1, hello2, counter])
}

struct CounterFairing;

#[rocket::async_trait]
impl Fairing for CounterFairing {
    fn info(&self) -> Info {
        Info {
            name: "Request Counter",
            kind: Kind::Request,
        }
    }

    async fn on_request(&self, request: &mut Request<'_>, _: &mut Data<'_>) {
        request
            .rocket()
            .state::<AppContext>()
            .unwrap()
            .counter
            .fetch_add(1, std::sync::atomic::Ordering::SeqCst);
    }
}

#[get("/")]
fn hello1() -> &'static str {
    "Hello World"
}

#[get("/hello/<name>")]
fn hello2(name: &str) -> String {
    format!("Hello, {}!", name)
}

#[get("/counter.json")]
fn counter(state: &State<AppContext>) -> Json<&AppContext> {
    Json(state.inner())
}
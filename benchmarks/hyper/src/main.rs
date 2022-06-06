use hyper::server::conn::AddrStream;
use hyper::service::{make_service_fn, service_fn};
use hyper::{Body, Request, Response, Server};
use std::convert::Infallible;
use std::sync::{atomic::AtomicUsize, Arc};

#[derive(Clone, Default)]
struct AppContext {
    pub counter: Arc<AtomicUsize>,
}

async fn handle(context: AppContext, req: Request<Body>) -> Result<Response<Body>, Infallible> {
    // Increment the visit count
    let new_count = context
        .counter
        .fetch_add(1, std::sync::atomic::Ordering::SeqCst);

    if req.method().as_str() != "GET" {
        return Ok(Response::builder().status(406).body(Body::empty()).unwrap());
    }

    let path = req.uri().path();
    let response = if path == "/" {
        Response::new(Body::from("Hello World"))
    } else if path == "/counter.json" {
        let data = format!("{{\"counter\":{}}}", new_count);
        Response::builder()
            .header("Content-Type", "application/json")
            .body(Body::from(data))
	        .unwrap()
    } else if let Some(name) = path.strip_prefix("/hello/") {
        Response::new(Body::from(format!("Hello, {}!", name)))
    } else {
        Response::builder().status(404).body(Body::empty()).unwrap()
    };
    Ok(response)
}

#[tokio::main]
async fn main() {
    let context = AppContext::default();

    let make_service = make_service_fn(move |_conn: &AddrStream| {
        let context = context.clone();
        let service = service_fn(move |req| handle(context.clone(), req));
        async move { Ok::<_, Infallible>(service) }
    });

    let server = Server::bind(&"127.0.0.1:3000".parse().unwrap())
        .serve(make_service)
        .await;

    if let Err(e) = server {
        eprintln!("server error: {}", e);
    }
}
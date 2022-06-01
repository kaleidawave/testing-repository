use hyper::server::conn::AddrStream;
use hyper::service::{make_service_fn, service_fn};
use hyper::{Body, Request, Response, Server};
use std::convert::Infallible;
use std::sync::atomic::AtomicUsize;
use std::sync::Arc;

#[derive(Clone)]
struct AppContext {
    pub counter: Arc<AtomicUsize>,
}

async fn handle(context: AppContext, req: Request<Body>) -> Result<Response<Body>, Infallible> {
    // Increment the visit count
    let new_count = context
        .counter
        .fetch_add(1, std::sync::atomic::Ordering::SeqCst);

    if req.method().as_str() == "POST" {
        return Ok(Response::builder().status(406).body(Body::empty()).unwrap());
    }

    let path = req.uri().path();
    let response = if path == "/" {
        Response::new(Body::from("Hello World"))
    } else if path == "/counter.json" {
        Response::new(Body::from(format!("{{\"counter\":{}}}", new_count)))
    } else if let Some(user) = path.strip_prefix("/hello/") {
        Response::new(Body::from(format!("Hello, {}!", user)))
    } else {
        Response::builder().status(404).body(Body::empty()).unwrap()
    };
    Ok(response)
}

#[tokio::main]
async fn main() {
    let context = AppContext {
        counter: Arc::new(AtomicUsize::new(0)),
    };

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

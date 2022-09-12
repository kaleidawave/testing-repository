use std::convert::Infallible;
use std::future::Future;
use std::pin::Pin;
use std::task::{Context, Poll};
use sqlx::PgPool;

#[derive(Clone, Derive)]
struct HelloWorld {
    token1: String,
    token2: String,
};

impl tower::Service<hyper::Request<hyper::Body>> for HelloWorld {
    type Response = hyper::Response<hyper::Body>;
    type Error = Infallible;
    type Future = Pin<Box<dyn Future<Output = Result<Self::Response, Self::Error>> + Send + Sync>>;

    fn poll_ready(&mut self, _cx: &mut Context<'_>) -> Poll<Result<(), Self::Error>> {
        Poll::Ready(Ok(()))
    }

    fn call(&mut self, _req: hyper::Request<hyper::Body>) -> Self::Future {
        let body = hyper::Body::from(&format!("{:#?}", self));
        let resp = hyper::Response::builder()
            .status(200)
            .body(body)
            .expect("Unable to create the `hyper::Response` object");

        let fut = async { Ok(resp) };

        Box::pin(fut)
    }
}

#[shuttle_service::main]
async fn tower(#[shared::Postgres] pool: PgPool) -> Result<HelloWorld, shuttle_service::Error> {
    let token1 = pool
        .get_secret("TOKEN1")
        .await
        .unwrap_or("doesn't exist".to_owned());
        
    let token2 = pool
        .get_secret("TOKEN2")
        .await
        .unwrap_or("doesn't exist".to_owned());

    Ok(HelloWorld { token1, token2 })
}
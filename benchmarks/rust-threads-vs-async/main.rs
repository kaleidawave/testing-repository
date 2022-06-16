// fn get_file_count() -> usize {
//     std::env::var("NUM_FILES")
//         .expect("Expected 'NUM_FILES' env variable")
//         .parse()
//         .expect("Expected 'NUM_FILES' env variable to be integer")
// }

const SERVER: &str = "localhost:8080";

#[cfg(not(feature = "async"))]
fn main() {
    fn sync_connect_and_read() {
        let _body: String = ureq::get(SERVER)
            .call()
            .unwrap()
            .into_string()
            .unwrap();
    }

    let mut handles = Vec::new();
    for i in 1..100 {
        if cfg!(feature = "threads") {
            let handle = std::thread::spawn(sync_connect_and_read);
            handles.push(handle);
        } else {
            sync_connect_and_read();
        }
    }
    handles
        .into_iter()
        .for_each(|handle| handle.join().unwrap());
}

#[cfg(feature = "async")]
#[cfg_attr(feature = "threads", tokio::main)]
#[cfg_attr(not(feature = "threads"), tokio::main(flavor = "current_thread"))]
async fn main() {
    use futures::future::join_all;
    use hyper::client::Client;
    use hyper::Uri;

    async fn async_connect_and_read<C, B>(client: Client<C, B>)
    where
        C: Connect + Clone + Send + Sync + 'static,
        B: HttpBody + Send + 'static,
        B::Data: Send,
        B::Error: Into<Box<dyn StdError + Send + Sync>>,
    {
        let future = client.get(Uri::from_static(SERVER)).await.unwrap();
    }

    let client = Client::new();

    let request_futures = (1..100).map(|_| async_connect_and_read(&client));
    join_all(request_futures).await;
}

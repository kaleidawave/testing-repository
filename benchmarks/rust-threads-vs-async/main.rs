// fn get_file_count() -> usize {
//     std::env::var("NUM_FILES")
//         .expect("Expected 'NUM_FILES' env variable")
//         .parse()
//         .expect("Expected 'NUM_FILES' env variable to be integer")
// }

const SERVER: &str = "127.0.0.1:8080";

#[cfg(not(feature = "async"))]
fn main() {
    fn sync_connect_and_read() {
        use std::net::TcpStream;
        let mut stream = TcpStream::connect(SERVER).unwrap();
        stream.write(&[1]).unwrap();
        stream.read(&mut [0; 128]).unwrap();
    }

    let mut handles = Vec::new();
    for i in 1..100 {
        if cfg!(feature = "threads") {
            let handle = std::thread::spawn(sync_connect_and_read);
            handles.push(handle);
        } else {
            sync_connect_and_read()
        }
    }
    handles.into_iter().for_each(|handle| handle.join().unwrap());
}

#[cfg(feature = "async")]
#[cfg_attr(feature = "threads", tokio::main)]
#[cfg_attr(not(feature = "threads"), tokio::main(flavor = "current_thread"))]
async fn main() {
    use futures::future::join_all;
    use tokio::net::TcpStream;
    use tokio::io::AsyncReadExt;

    async fn async_connect_and_read() {
        let mut stream = TcpStream::connect(SERVER).await.unwrap();
        let mut buffer = String::new();
        stream.read_to_string(&mut buffer).await.unwrap();
    }

    let request_futures = (1..100).map(|_| async_connect_and_read());
    join_all(request_futures).await;
}

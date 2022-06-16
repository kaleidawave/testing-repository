#[cfg(not(feature = "async"))]
fn main() {
    use std::thread;

    let mut handles = Vec::new();
    for i in 1..100 {
        let path = format!("files/{}", i);
        if cfg!(feature = "threads") {
            let handle = thread::spawn(move || {
                let _x = std::fs::read_to_string(&path);
            });
            handles.push(handle);
        } else {
            let _x = std::fs::read_to_string(&path);
        }
    }
    handles.into_iter().for_each(|handle| handle.join().unwrap());
}

#[cfg(feature = "async")]
#[cfg_attr(feature = "threads", tokio::main)]
#[cfg_attr(not(feature = "threads"), tokio::main(flavor = "current_thread"))]
async fn main() {
    use futures::future::join_all;

    async fn read_file(path: String) {
        let _x = tokio::fs::read(&path).await.unwrap();
    }

    let file_read_futures = (1..100).map(|i| read_file(format!("files/{}", i)));
    join_all(file_read_futures).await;
}

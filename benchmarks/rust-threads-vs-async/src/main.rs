fn get_file_count() -> usize {
    std::env::var("NUM_FILES")
        .expect("Expected 'NUM_FILES' env variable")
        .parse()
        .expect("Expected 'NUM_FILES' env variable to be integer")
}

#[cfg(not(feature = "async"))]
fn main() {
    use std::thread;

    let mut handles = Vec::new();
    for i in 1..get_file_count() {
        let read_path = format!("files/{}", i);
        let write_path = format!("out/{}", i);
        if cfg!(feature = "threads") {
            let handle = thread::spawn(move || {
                let content = std::fs::read_to_string(&read_path).unwrap();
                std::fs::write(write_path, content);
            });
            handles.push(handle);
        } else {
            let content = std::fs::read_to_string(&read_path).unwrap();
            std::fs::write(write_path, content);
        }
    }
    handles.into_iter().for_each(|handle| handle.join().unwrap());
}

#[cfg(feature = "async")]
#[cfg_attr(feature = "threads", tokio::main)]
#[cfg_attr(not(feature = "threads"), tokio::main(flavor = "current_thread"))]
async fn main() {
    use futures::future::join_all;
    use tokio::fs;

    async fn move_file(path: String) {
        let content = fs::read(&path).await.unwrap();
        fs::write(&path, content).await.unwrap();
    }

    let file_move_futures = (1..get_file_count()).map(|i| move_file(format!("files/{}", i)));
    join_all(file_move_futures).await;
}

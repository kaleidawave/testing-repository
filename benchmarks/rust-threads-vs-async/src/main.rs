#[cfg(not(feature = "async"))]
fn main() {
    let mut handles = Vec::new();
    for i in 1..100 {
        let path = format!("files/{}", i);
        if cfg!(feature = "threads") {
            let handle = thread::spawn(|| {
                let _x = std::fs::read_to_string(&path);
            });
            handles.push(handle);
        } else {
            let _x = std::fs::read_to_string(&path);
        }
    }
    handles.into_iter(|handle| handle.join().unwrap());
}

#[cfg(feature = "async")]
#[cfg_attr(feature = "threads", tokio::main)]
#[cfg_attr(not(feature = "threads"), tokio::main(flavor = "current_thread"))]
async fn main() {
    println!("Hello, world!");
}


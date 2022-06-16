use std::time::Instant;

fn main() {
    {
        let now = Instant::now();
        let elapsed = now.elapsed();
        println!("Standard {:?}", elapsed);

        let now = Instant::now();
        println!("Standard inline {:?}", now.elapsed());
    }

    let now = Instant::now();
    tokio::runtime::Builder::new_multi_thread()
        .enable_all()
        .build()
        .unwrap()
        .block_on(async move {
            let elapsed = now.elapsed();
            println!("Tokio {:?}", elapsed);
        });

    let elapsed = now.elapsed();
    println!("Tokio shutdown {:?}", elapsed);
}

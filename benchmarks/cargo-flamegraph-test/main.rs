use std::{thread, time};

fn main() {
    println!("Hello, world!");

    wait5seconds();
    wait8seconds();
    wait5seconds();

    println!("Bye!");
}

fn wait5seconds() {
    let duration = time::Duration::from_secs(5);
    thread::sleep(duration);
}

fn wait8seconds() {
    let duration = time::Duration::from_secs(8);
    thread::sleep(duration);
}

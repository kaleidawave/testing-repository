use std::io::Write;
use std::fs::File;

fn main() {
    println!("cwd={cwd:?}", cwd=std::env::current_dir());

    for (variable, value) in std::env::vars() {
        println!("{variable} = {value:?}");
    }

    {
        let file = std::env::vars()
            .find_map(|(name, value)| (name == "GITHUB_OUTPUT").then_some(value));
        if let Some(file) = file {
            let (name, value) = ("hi", "value");
            writeln!(&mut File::options().append(true).open(file).unwrap(), "{name}={value}").unwrap();
        } else {
            eprintln!("no GITHUB_OUTPUT variable");
        }
    }
 
    {
        let file = std::env::vars()
            .find_map(|(name, value)| (name == "GITHUB_STEP_SUMMARY").then_some(value));
        if let Some(file) = file {
            eprintln!("GITHUB_STEP_SUMMARY points to {file}");
            writeln!(&mut File::options().append(true).open(file).unwrap(), "Hello world").unwrap();
        } else {
            eprintln!("no GITHUB_STEP_SUMMARY variable");
        }
    }

    {
        let message = "this is a notice";
        println!("::notice::{message}");
    }
}

use std::fs::{read_dir, read_to_string, write};
use std::path::{Path, PathBuf};
// use termcolor::{BufferWriter, Color, ColorChoice, ColorSpec, WriteColor};
// use std::io::Write;
use std::fmt::Write;

fn main() {
    let path: &Path = &PathBuf::from("./test262/src");
    let mut valid = String::new();
    let mut invalid = String::new();

    visit_dirs(path, &mut |path| {
        let source = read_to_string(path).unwrap();

        let start = source.find("/*---").unwrap() + "/*---".len();
        let remaining = &source[start..];
        let end = remaining.find("---*/").unwrap();

        {
            let options = &remaining[..end];
            let result = simple_yaml_parser::parse(options, |_key, _value| {
                // ...
            });

            match result {
                Ok(..) => writeln!(&mut valid, "{path}", path = path.display()).unwrap(),
                Err(err) => {
                    writeln!(&mut invalid, "{path} {err:?}", path = path.display()).unwrap()
                }
            };
        }
    });

    write("out/valid.txt", valid).unwrap();
    write("out/invalid.txt", invalid).unwrap();
}

fn visit_dirs(path: &Path, cb: &mut impl FnMut(&Path)) {
    if path.is_dir() {
        for entry in read_dir(path).unwrap() {
            let entry = entry.unwrap();
            let path = entry.path();
            if path.is_dir() {
                visit_dirs(&path, cb);
            } else {
                cb(&path);
            }
        }
    }
}

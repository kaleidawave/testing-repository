use std::fs::{read_dir, read_to_string, write};
use std::path::{Path, PathBuf};
// use termcolor::{BufferWriter, Color, ColorChoice, ColorSpec, WriteColor};
// use std::io::Write;
use std::fmt::Write;

fn main() {
    let path: &Path = &PathBuf::from("./test262/test");
    let mut valid = String::new();
    let mut invalid = String::new();

    let mut completed = 0;
    let mut successful = 0;
    let mut expected_invalid_parses = 0;
    visit_dirs(path, &mut |path| {
        if let Some("js") = path.extension().and_then(std::ffi::OsStr::to_str) {
            let Ok(source) = read_to_string(path) else {
                eprintln!("Could not read {path}", path = path.display());
                return;
            };

            let Some(start) = source.find("/*---") else {
                eprintln!("No /*--- under {path}", path = path.display());
                return;
            };
            let start = start + "/*---".len();

            let remaining = &source[start..];
            let Some(end) = remaining.find("---*/") else {
                eprintln!("No ---*/ under {path}", path = path.display());
                return;
            };

            let metadata = &remaining[..end];

            let end = end + "/*---".len();
            let code = &remaining[end..];

            let mut should_not_parse = false;
            {
                let result = simple_yaml_parser::parse(metadata, |key, value| {
                    if let (
                        &[
                            simple_yaml_parser::YAMLKey::Slice("negative"),
                            simple_yaml_parser::YAMLKey::Slice("phase"),
                        ],
                        simple_yaml_parser::RootYAMLValue::String("parse"),
                    ) = (key, value)
                    {
                        should_not_parse = true;
                    }
                });

                if let Err(err) = result {
                    writeln!(
                        &mut invalid,
                        "yaml-parse {path} {err:?}",
                        path = path.display()
                    )
                    .unwrap();
                    return;
                }
            };

            if should_not_parse {
                expected_invalid_parses += 1;
            }

            let result = <ezno_parser::Module as ezno_parser::ASTNode>::from_string_with_options(
                code.into(),
                Default::default(),
                None,
            );

            match result {
                Ok(_) if should_not_parse => writeln!(
                    &mut invalid,
                    "js-parse   {path} (should not parse)",
                    path = path.display()
                )
                .unwrap(),
                Err(_) if !should_not_parse => writeln!(
                    &mut invalid,
                    "js-parse   {path} (should parse but errored)",
                    path = path.display()
                )
                .unwrap(),
                _ => {
                    writeln!(
                        &mut valid,
                        "js-parse   {path} ✅✅✅",
                        path = path.display()
                    );
                    successful += 1;
                }
            }

            completed += 1;
        } else {
            eprintln!("Non test file {path}", path = path.display());
        }
    });

    eprintln!(
        "Completed {completed} files. {expected_invalid_parses} tests for bad parsing. {successful} successful passes. {errors} fails",
        errors = completed - successful
    );

    write("valid.txt", valid).unwrap();
    write("invalid.txt", invalid).unwrap();
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

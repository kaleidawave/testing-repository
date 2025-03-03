use std::borrow::Cow;
use std::fs::{create_dir, read_dir, read_to_string};
use std::path::{Path, PathBuf};

fn main() {
    let path: &Path = &PathBuf::from("./test262/test");

    let mut completed = 0;
    let mut successful = 0;

    let now = std::time::Instant::now();

    let _ = create_dir("out");
    let connection = sqlite::open("out/database.db").unwrap();

    let query = "CREATE TABLE results (
    path        TEXT PRIMARY KEY,
    info        TEXT,
    negative    INTEGER,
    code        TEXT,
    pass        INTEGER,
    parser_out  TEXT
);";
    connection.execute(query).unwrap();

    let query = "INSERT INTO results VALUES (:path, :info, :negative, :code, :pass, :parser_out)";
    let mut statement = connection.prepare(query).unwrap();

    visit_dirs(path, &mut |path| {
        if let Some(path) = path.file_name().and_then(std::ffi::OsStr::to_str) {
            if path.contains("_FIXTURE") {
                return;
            }
        }

        if let Some("js") = path.extension().and_then(std::ffi::OsStr::to_str) {
            let Ok(source) = read_to_string(path) else {
                eprintln!("Could not read {path}", path = path.display());
                return;
            };

            let Some(start) = source.find("/*---") else {
                eprintln!("No '/*---' under {path}", path = path.display());
                return;
            };
            let start = start + "/*---".len();

            let remaining = &source[start..];
            let Some(end) = remaining.find("---*/") else {
                eprintln!("No '---*/' under {path}", path = path.display());
                return;
            };

            let metadata = &remaining[..end];

            let end = end + "---*/".len();
            let code = &remaining[end..];

            // Set by metadata
            let mut should_not_parse = false;
            let mut info = "";

            {
                let result = simple_yaml_parser::parse(metadata, |key, value| {
                    // TODO description. negative.type, flags, locale
                    if let (
                        &[
                            simple_yaml_parser::YAMLKey::Slice("negative"),
                            simple_yaml_parser::YAMLKey::Slice("phase"),
                        ],
                        simple_yaml_parser::RootYAMLValue::String("parse"),
                    ) = (key, &value)
                    {
                        should_not_parse = true;
                    } else if let (
                        &[simple_yaml_parser::YAMLKey::Slice("info")],
                        simple_yaml_parser::RootYAMLValue::String(content),
                    ) = (key, value)
                    {
                        info = content;
                    }
                });

                if let Err(err) = result {
                    eprintln!("yaml-parse {path} {err:?}", path = path.display());
                    return;
                }
            };

            let result = <ezno_parser::Module as ezno_parser::ASTNode>::from_string_with_options(
                code.into(),
                Default::default(),
                None,
            );

            let (matched, reason) = match result {
                Ok(_) if should_not_parse => {
                    (false, Cow::Borrowed("parsed when should have failed"))
                }
                Err(error) if !should_not_parse => (false, Cow::Owned(error.reason)),
                _ => {
                    successful += 1;
                    // TODO should emit -> parse -> emit and check results (roundtrip)
                    // TODO should type check
                    (true, Cow::Borrowed(""))
                }
            };

            {
                // let query = "INSERT INTO results VALUES (:path, :info, :negative, :code, :pass, :parser_out)";
                let values = &[
                    (":path", path.display().to_string().into()),
                    (":info", info.into()),
                    (":negative", (should_not_parse as i64).into()),
                    // space saving measure
                    (":code", (if matched { "" } else { code }).into()),
                    (":pass", (matched as i64).into()),
                    (":parser_out", (&*reason).into()),
                ];
                statement
                    .bind::<&[(_, sqlite::Value)]>(values)
                    .expect("Could not bind");

                while let Ok(sqlite::State::Row) = statement.next() {}
                let _ = statement.reset();
            }

            completed += 1;
        } else {
            eprintln!("Not a test file: {path}", path = path.display());
        }
    });

    eprintln!(
        "Completed {completed} tests in {duration:?}. {successful} successful passes. {errors} fails",
        errors = completed - successful,
        duration = now.elapsed()
    );

    // write("out/valid.txt", valid).unwrap();
    // write("out/invalid.txt", invalid).unwrap();
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

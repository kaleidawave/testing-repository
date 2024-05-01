use codespan_reporting::{
    diagnostic::{Diagnostic, Label, Severity},
    term::{
        emit,
        termcolor::{ColorChoice, StandardStream, BufferedStandardStream},
        Config, DisplayStyle,
    },
};
use source_map::{FileSystem, MapFileStore, PathMap, SourceId, SpanWithSource, WithPathMap};
use std::time::Instant;
use thousands::Separable;

const COMPACT: bool = option_env!("COMPACT").is_some();
const LOCKED: bool = option_env!("LOCKED").is_some();
const BUFFERED: bool = option_env!("BUFFERED").is_some();
const BUFFERED2: bool = option_env!("BUFFERED2").is_some();

const CONTENT: &str = include_str!("./demo.ts");

pub mod checker {
    use super::{SourceId, SpanWithSource};

    pub fn get_diagnostics(source: SourceId) -> Vec<Diagnostic> {
        use self::{Diagnostic::*, DiagnosticKind::*};

        let span = |a: std::ops::Range<u32>| SpanWithSource {
            start: a.start,
            end: a.end,
            source,
        };

        include!("diagnostics.rs")
    }

    #[derive(Debug, Clone, Copy)]
    pub enum DiagnosticKind {
        Error,
        Warning,
        Info,
    }

    /// Contains information
    #[derive(Debug)]
    pub enum Diagnostic {
        /// Does not have positional information
        Global {
            reason: String,
            kind: DiagnosticKind,
        },
        Position {
            reason: String,
            position: SpanWithSource,
            kind: DiagnosticKind,
        },
        PositionWithAdditionalLabels {
            reason: String,
            position: SpanWithSource,
            labels: Vec<(String, Option<SpanWithSource>)>,
            kind: DiagnosticKind,
        },
    }
}

fn ezno_diagnostic_to_severity(kind: &checker::DiagnosticKind) -> Severity {
    match kind {
        checker::DiagnosticKind::Error => Severity::Error,
        checker::DiagnosticKind::Warning => Severity::Warning,
        checker::DiagnosticKind::Info => Severity::Note,
    }
}

/// If pretty printing, it looks nice to include the message under the label, rather than as a heading. However under
/// compact mode the label isn't printed, so instead do the opposite in the compact case
fn checker_diagnostic_to_codespan_diagnostic(
    diagnostic: checker::Diagnostic,
    compact: bool,
) -> Diagnostic<SourceId> {
    match diagnostic {
        checker::Diagnostic::Global { reason, kind } => Diagnostic {
            severity: ezno_diagnostic_to_severity(&kind),
            code: None,
            message: reason,
            labels: Vec::new(),
            notes: Vec::default(),
        },
        checker::Diagnostic::Position {
            reason,
            position,
            kind,
        } => {
            let (message, labels) = if compact {
                (reason, Vec::new())
            } else {
                (
                    String::new(),
                    vec![Label::primary(position.source, position).with_message(reason)],
                )
            };

            Diagnostic {
                severity: ezno_diagnostic_to_severity(&kind),
                code: None,
                message,
                labels,
                notes: Vec::default(),
            }
        }
        checker::Diagnostic::PositionWithAdditionalLabels {
            reason,
            position,
            labels,
            kind,
        } => {
            let mut diagnostic = Diagnostic {
                severity: ezno_diagnostic_to_severity(&kind),
                code: None,
                message: String::new(),
                labels: Vec::new(),
                notes: Vec::new(),
            };

            if compact {
                diagnostic.message = reason;
            } else {
                let main_label = Label::primary(position.source, position).with_message(reason);
                diagnostic.labels.push(main_label);

                for (message, position) in labels {
                    if let Some(position) = position {
                        diagnostic.labels.push(
                            Label::secondary(position.source, position).with_message(message),
                        );
                    } else {
                        diagnostic.notes.push(message)
                    }
                }
            }

            diagnostic
        }
    }
}

pub(crate) fn emit_diagnostics<T: PathMap>(
    diagnostics: impl IntoIterator<Item = checker::Diagnostic>,
    fs: &MapFileStore<T>,
    compact: bool,
) -> Result<(), codespan_reporting::files::Error> {
    // TODO custom here
    let config = Config {
        display_style: if compact {
            DisplayStyle::Short
        } else {
            DisplayStyle::Rich
        },
        ..Config::default()
    };

    let files = fs.into_code_span_store();

    if BUFFERED2 {
        let mut writer = BufferedStandardStream::stderr(ColorChoice::Auto);
        for diagnostic in diagnostics {
            let diagnostic = checker_diagnostic_to_codespan_diagnostic(diagnostic, compact);
            emit(&mut writer, &config, &files, &diagnostic)?;
        }

        return Ok(());
    }

    let mut writer = StandardStream::stderr(ColorChoice::Auto);
    if LOCKED {
        let mut writer = writer.lock();
        for diagnostic in diagnostics {
            let diagnostic = checker_diagnostic_to_codespan_diagnostic(diagnostic, compact);
            emit(&mut writer, &config, &files, &diagnostic)?;
        }
    } else if BUFFERED {
        let mut writer = codespan_reporting::term::termcolor::Buffer::ansi();

        {
            let now = Instant::now();
            for diagnostic in diagnostics {
                let diagnostic = checker_diagnostic_to_codespan_diagnostic(diagnostic, compact);
                emit(&mut writer, &config, &files, &diagnostic)?;
            }
            let duration = now.elapsed().as_micros().separate_with_commas();
            println!("Building diagnostics in {duration}µs");
        }

        {
            use std::io::{stderr, Write};
            let now = Instant::now();
            let mut stderr = stderr().lock();
            stderr.write(writer.as_slice()).unwrap();
            let duration = now.elapsed().as_micros().separate_with_commas();
            println!("Writing buffered diagnostics in {duration}µs");
        }
    } else {
        for diagnostic in diagnostics {
            let diagnostic = checker_diagnostic_to_codespan_diagnostic(diagnostic, compact);
            emit(&mut writer, &config, &files, &diagnostic)?;
        }
    };

    Ok(())
}

fn main() {
    let mut files = MapFileStore::<WithPathMap>::default();

    let source_id = files.new_source_id("./demo.ts".into(), CONTENT.to_string());

    // let repeat = 1;

    let now = Instant::now();
    let diagnostics = checker::get_diagnostics(source_id);
    let duration = now.elapsed().as_micros().separate_with_commas();
    println!("Getting diagnostics in {duration}µs");

    let _ = emit_diagnostics(diagnostics, &files, COMPACT);

    let duration = now.elapsed().as_micros().separate_with_commas();

    println!("Printing diagnostics in {duration}µs (COMPACT={COMPACT:?}, LOCKED={LOCKED:?}, BUFFERED={BUFFERED:?})");
}

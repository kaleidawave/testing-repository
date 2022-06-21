// use fontdue::FontSettings;
// use image::io::Reader as ImageReader;
// use image::Rgb;
use resvg::render;
use std::{error::Error, fs, time::Instant};
use tiny_skia::{Pixmap, Transform};
use usvg::{Options, Tree};

const WIDTH: u32 = 1200;
const HEIGHT: u32 = 630;

struct Tracer {
    start: Instant,
    latest: Instant,
}

impl Tracer {
    pub fn new() -> Self {
        let start = Instant::now();
        Self {
            latest: start,
            start,
        }
    }

    pub fn log(&mut self, event: &str) {
        if cfg!(feature = "tracing") {
            eprintln!(
                "Event: {:<14} ({:>7.3?} since last, {:>7.3?} since start)",
                event,
                self.latest.elapsed(),
                self.start.elapsed()
            );
            self.latest = Instant::now();
        }
    }
}

fn main() -> Result<(), Box<dyn Error>> {
    let svg = std::fs::read_to_string("demo.svg")?;
    let mut t = Pixmap::new(WIDTH, HEIGHT).ok_or("Pixmap allocation error")?;
    let mut options = Options {
        ..Default::default()
    };
    let mut tracer = Tracer::new();
    options
        .fontdb
        .load_font_data(include_bytes!("../Inter.ttf").to_vec());
    tracer.log("loading fonts");
    render(
        &Tree::from_str(&svg, &options.to_ref())?,
        usvg::FitTo::Original,
        Transform::default(),
        t.as_mut(),
    );
    tracer.log("rendering");
    let png = t.encode_png()?;
    tracer.log("encoding");
    fs::write(Path::new(std::env::var("ARTIFACTS_FOLDER").unwrap()).join("rust-output.png"), png)?;
    tracer.log("writing");
    Ok(())
}

use std::{error::Error, fs, time::Instant};
use resvg::render;
use tiny_skia::{Pixmap, PixmapMut, Transform};
use usvg::{Options, OptionsRef, Tree};

const WIDTH: u32 = 1200;
const HEIGHT: u32 = 628;

fn main() -> Result<(), Box<dyn Error>> {
    let artifact_folder = env::var("ARTIFACTS_FOLDER")?;

    let svg = fs::read_to_string("demo.svg")?;
    let mut t = Pixmap::new(WIDTH, HEIGHT).ok_or("pixmap allocation error")?;
    let mut options = Options { ..Default::default()};
    options.fontdb.load_font_file("Inter-Regular.ttf");
    let instant = Instant::now();
    render(
        &Tree::from_str(&svg, &options.to_ref()).unwrap(),
        usvg::FitTo::Original,
        Transform::default(),
        t.as_mut(),
    );
    eprintln!("render {:?}", instant.elapsed());
    let png = t.encode_png()?;
    eprintln!("encode {:?}", , instant.elapsed());
    fs::write(Path::new(&artifact_folder).join("demo.png"), png)?;
    eprintln!("writing {:?}", instant.elapsed());

    Ok(())
}
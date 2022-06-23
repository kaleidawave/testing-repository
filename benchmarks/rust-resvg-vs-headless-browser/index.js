const puppeteer = require('puppeteer');
const path = require('path');

(async () => {
  const browser = await puppeteer.launch();
  const page = await browser.newPage();
  if (process.env.SINGLE_RUN) {
    await page.goto('file://' + path.join(process.cwd(), "./ferris.svg"));
    await page.screenshot({ 
      path: path.join(process.env.ARTIFACTS_FOLDER, 'node-output.webp'), 
      clip: { x: 0, y: 0, width: 1200, height: 630 }, 
      quality: 100 
    });
  } else {
    for (let i = 0; i < 10; i++) {
      console.time("Load And Screenshot time");
      await page.goto('file://' + path.join(process.cwd(), "./ferris.svg"));
      console.time("Screenshot time");
      await page.screenshot({ 
        path: path.join(process.env.ARTIFACTS_FOLDER, 'node-output.webp'), 
        clip: { x: 0, y: 0, width: 1200, height: 630 }, 
        quality: 100 
      });
      console.timeEnd("Screenshot time");
      console.timeEnd("Load And Screenshot time");
    }
  }
  await browser.close();
})();
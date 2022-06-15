const puppeteer = require('puppeteer');
const path = require('path');

(async () => {
  const browser = await puppeteer.launch();
  const page = await browser.newPage();
  await page.goto('https://kaleidawave.github.io/');
  console.time("Screenshot time");
  await page.screenshot({ path: path.join(process.env.ARTIFACTS_FOLDER, 'screenshot.png') });
  console.timeEnd("Screenshot time");

  await browser.close();
})();
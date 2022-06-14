const puppeteer = require('puppeteer');
const path = require('path');

(async () => {
  const browser = await puppeteer.launch();
  const page = await browser.newPage();
  await page.goto('https://kaleidawave.github.io/');
  await page.screenshot({ path: path.join(process.env.ARTIFACTS_FOLDER, 'screenshot.png') });

  await browser.close();
})();
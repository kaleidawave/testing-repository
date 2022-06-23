const puppeteer = require('puppeteer');
const path = require('path');

(async () => {
  const browser = await puppeteer.launch();
  const page = await browser.newPage();
  await page.goto('file://' + path.join(process.cwd(), "./ferris.svg"));
  for (let i = 0; i < 10; i++) {
    console.time("Screenshot time");
    await page.screenshot({ path: path.join(process.env.ARTIFACTS_FOLDER, 'node-output.webp') });
    console.timeEnd("Screenshot time");
    await browser.close();
  }
})();
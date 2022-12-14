const puppeteer = require('puppeteer');

(async () => {
  console.log(" ---> Launching Puppeteer ")
  const browser = await puppeteer.launch({
    headless: true,
    args: [
        "--disable-gpu",
        "--disable-dev-shm-usage",
        "--disable-setuid-sandbox",
        "--no-sandbox",
        "--disable-setuid-sandbox"
    ]
});
  const page = await browser.newPage();
  await page.goto('https://example.com');
  await page.screenshot({path: 'example.png'});
  await browser.close();
  console.log(" ---> Puppeteer Ran Successfully")
})();
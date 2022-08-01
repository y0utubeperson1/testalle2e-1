import asyncio
from pyppeteer import launch

async def main():
    browser = await launch(executablePath='/usr/bin/google-chrome-stable', headless=True, args=['--no-sandbox'])
    page = await browser.newPage()
    await browser.close()

asyncio.get_event_loop().run_until_complete(main())
#!/usr/bin/env python3
"""
Google Dork Batch Opener
Opens search queries from a .txt file, 5 at a time in separate Chromium windows.
When one window closes, the next query opens automatically.
"""

import sys
import os
import time
import shutil
import platform
import urllib.parse
from selenium import webdriver
from selenium.webdriver.chrome.options import Options

MAX_CONCURRENT = 5

def banner():
    print(r"""
   ______        ______
  /      \      /      \
 |  ()()  |----|  ()()  |
  \______/      \______/
        DORK OPENER
""")

def load_dorks(path):
    with open(path, "r", encoding="utf-8") as f:
        return [line.strip() for line in f if line.strip()]

def chromium_path():
    if platform.system() == "Windows":
        for p in [
            r"C:\Program Files\Chromium\Application\chrome.exe",
            r"C:\Program Files (x86)\Chromium\Application\chrome.exe",
        ]:
            if os.path.exists(p):
                return p
    else:
        found = shutil.which("chromium") or shutil.which("chromium-browser")
        if found:
            return found
    return None  # fall back to Selenium auto-detection

def make_driver():
    opts = Options()
    path = chromium_path()
    if path:
        opts.binary_location = path
    opts.add_experimental_option("detach", False)
    return webdriver.Chrome(options=opts)

def open_dork(dork):
    driver = make_driver()
    url = "https://www.google.com/search?q=" + urllib.parse.quote(dork)
    driver.get(url)
    return driver

def is_alive(driver):
    try:
        _ = driver.window_handles
        return len(driver.window_handles) > 0
    except Exception:
        return False

def main():
    banner()
    if len(sys.argv) < 2:
        print("Usage: python dork.py dorks.txt")
        sys.exit(1)

    dorks = load_dorks(sys.argv[1])
    if not dorks:
        print("No dorks found in file.")
        sys.exit(0)

    print(f"Loaded {len(dorks)} dorks. Keeping {MAX_CONCURRENT} open at a time.")

    queue = list(dorks)
    active = []

    try:
        while queue or active:
            while queue and len(active) < MAX_CONCURRENT:
                dork = queue.pop(0)
                try:
                    driver = open_dork(dork)
                    active.append((driver, dork))
                    print(f"Opened: {dork}   ({len(active)} active, {len(queue)} queued)")
                except Exception as e:
                    print(f"Failed to open '{dork}': {e}")

            still_active = []
            for driver, dork in active:
                if is_alive(driver):
                    still_active.append((driver, dork))
                else:
                    print(f"Closed:  {dork}")
                    try:
                        driver.quit()
                    except Exception:
                        pass
            active = still_active

            time.sleep(1)

    except KeyboardInterrupt:
        print("\nInterrupted. Closing all windows...")
        for driver, _ in active:
            try:
                driver.quit()
            except Exception:
                pass

    print("All dorks processed.")

if __name__ == "__main__":
    main()
# Python Dork Opener

Opens Google search queries (dorks) from a text file in batches of 5 Chromium
windows. When you close one window, the next query in the list opens
automatically until the list is finished. Useful for OSINT, security research,
and SEO/site auditing.

## Requirements
- Python 3
- Chromium

## Setup

### Arch Linux
````bash
git clone https://github.com/yourname/python-dork-opener.git
cd python-dork-opener
chmod +x install.sh
./install.sh
````

### Windows

````cmd
git clone https://github.com/cnmoseman/python-dork-opener.git
cd python-dork-opener
install.bat
````

The install script installs Chromium (if missing), creates a virtual
environment, and installs dependencies.

## Usage

Put one query per line in `dorks.txt`, then:

**Arch**

````bash
source venv/bin/activate
python dork.py dorks.txt
````

**Windows**

````cmd
venv\Scripts\activate.bat
python dork.py dorks.txt
````

Or pass the file straight to the installer to set up and launch in one step:
`./install.sh dorks.txt` / `install.bat dorks.txt`.

## Notes

Google rate-limits automated queries and may show CAPTCHAs if you open many in
quick succession. Use responsibly and only against targets you're authorized to
research.

## License

MIT
# Python Dork Opener

Opens Google search queries (dorks) from a text file in batches of 5 Chromium
windows. When you close one window, the next query in the list opens
automatically until the list is finished. Useful for OSINT, security research
on your own properties, and SEO/site auditing.

## Requirements
- Python 3
- Chromium

## Setup

### Arch Linux
```bash
git clone https://github.com/yourname/python-dork-opener.git
cd python-dork-opener
chmod +x install.sh
./install.sh
```

Then add the launcher to your PATH (one time):
```fish
# fish
fish_add_path ~/.local/bin
```
```bash
# bash / zsh — add to your ~/.bashrc or ~/.zshrc
export PATH="$HOME/.local/bin:$PATH"
```

### Windows
```cmd
git clone https://github.com/yourname/python-dork-opener.git
cd python-dork-opener
install.bat
```

The installer adds a `dork` command to `%USERPROFILE%\bin`. Add that folder to
your PATH if the installer prompts you to, then open a **new** terminal.

## Usage

Put one query per line in `dorks.txt`, then simply run:

```
dork dorks.txt
```

The `dork` command works from any directory—it activates the virtual
environment and launches the tool for you. Windows open five at a time and a
new query opens each time you close one, until the list is done. Press
`Ctrl+C` to stop and close everything.

### Running without the launcher
If you'd rather run it directly:

**Arch (fish)**
```fish
source venv/bin/activate.fish
python dork.py dorks.txt
```

**Arch (bash/zsh)**
```bash
source venv/bin/activate
python dork.py dorks.txt
```

**Windows**
```cmd
venv\Scripts\activate.bat
python dork.py dorks.txt
```

## Intended use
This tool is for authorized research—your own sites, systems you have
permission to test, and general learning. Google rate-limits automated queries
and may show CAPTCHAs if you open many in quick succession, so space out large
lists. Surfacing or accessing data you aren't authorized to view can cross
legal lines regardless of how it's found; keep your use within scope.

## License
MIT
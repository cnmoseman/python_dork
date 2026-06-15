# Python Dork Opener

```
   ______        ______
  /      \      /      \
 |  ()()  |----|  ()()  |
  \______/      \______/
        DORK OPENER
```

Opens Google search queries (dorks) from a text file in batches of 5 Chromium
windows. When you close one window, the next query in the list opens
automatically until the list is finished. Useful for OSINT, security research
on your own properties, and SEO/site auditing.

## Requirements

- **Python 3**
- **Chromium**
- One Python package: **`selenium`** (installed automatically by the setup script)

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
# bash / zsh — add to ~/.bashrc or ~/.zshrc
export PATH="$HOME/.local/bin:$PATH"
```

### Windows
```cmd
git clone https://github.com/yourname/python-dork-opener.git
cd python-dork-opener
.\install.bat
```

The installer creates a `dork` command in `%USERPROFILE%\bin` and adds it to
your user PATH automatically. **Open a new terminal** afterward so the PATH
change takes effect.

## Usage

Put one query per line in `dorks.txt`, then run:

```
dork dorks.txt
```

The `dork` command works from any directory—it activates the virtual
environment and launches the tool for you. Windows open five at a time, and a
new query opens each time you close one, until the list is finished. Press
`Ctrl+C` to stop and close everything.

### Running without the launcher

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

## Troubleshooting

- **`dork: command not found` / not recognized** — open a *new* terminal; the
  PATH change only applies to terminals opened after install.
- **fish: `case builtin not inside of switch block`** — you sourced the bash
  activate script. Use `source venv/bin/activate.fish` instead.
- **winget says "already installed"** — that's fine, Chromium is present; the
  installer continues normally.
- **Google CAPTCHAs** — Google rate-limits automated queries. Space out large
  lists or run smaller batches.

## Intended use

This tool is for authorized research—your own sites, systems you have
permission to test, and general learning. Surfacing or accessing data you
aren't authorized to view can cross legal lines regardless of how it's found;
keep your use within scope.

## License

MIT

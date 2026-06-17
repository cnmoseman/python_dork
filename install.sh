#!/usr/bin/env bash
set -e

echo "=== Python Dork Opener - Arch setup (Chromium) ==="

if ! command -v python3 >/dev/null 2>&1; then
    echo "Installing Python..."
    sudo pacman -S --needed --noconfirm python
fi

if ! command -v chromium >/dev/null 2>&1; then
    echo "Installing Chromium..."
    sudo pacman -S --needed --noconfirm chromium
fi

INSTALL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$INSTALL_DIR"

if [ -x "$INSTALL_DIR/venv/bin/python" ]; then
    echo "Virtual environment already exists, skipping creation."
else
    python3 -m venv "$INSTALL_DIR/venv"
fi

"$INSTALL_DIR/venv/bin/python" -m pip install --upgrade pip
"$INSTALL_DIR/venv/bin/python" -m pip install -r "$INSTALL_DIR/requirements.txt"

mkdir -p "$HOME/.local/bin"
LAUNCHER="$HOME/.local/bin/dork"

cat > "$LAUNCHER" <<EOF
#!/usr/bin/env bash
exec "$INSTALL_DIR/venv/bin/python" "$INSTALL_DIR/dork.py" "\$@"
EOF
chmod +x "$LAUNCHER"

echo ""
echo "Setup complete."
echo "A 'dork' command was installed to ~/.local/bin/"
echo ""
echo "Make sure ~/.local/bin is on your PATH."
echo "  fish:      fish_add_path ~/.local/bin"
echo "  bash/zsh:  add to your rc file: export PATH=\"\$HOME/.local/bin:\$PATH\""
echo ""
echo "Then open a NEW terminal and run:  dork dorks.txt"#!/usr/bin/env bash
set -e

echo "=== Python Dork Opener — Arch setup (Chromium) ==="

if ! command -v python3 >/dev/null 2>&1; then
    echo "Installing Python..."
    sudo pacman -S --needed --noconfirm python
fi

if ! command -v chromium >/dev/null 2>&1; then
    echo "Installing Chromium..."
    sudo pacman -S --needed --noconfirm chromium
fi

python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install selenium

# --- Install a `dork` launcher command ---
INSTALL_DIR="$(pwd)"
LAUNCHER="$HOME/.local/bin/dork"
mkdir -p "$HOME/.local/bin"

cat > "$LAUNCHER" <<EOF
#!/usr/bin/env bash
cd "$INSTALL_DIR"
source venv/bin/activate
exec python dork.py "\$@"
EOF

chmod +x "$LAUNCHER"

echo ""
echo "Setup complete."
echo "A 'dork' command was installed to ~/.local/bin/"
echo ""
echo "Make sure ~/.local/bin is in your PATH. For fish, run:"
echo "    fish_add_path ~/.local/bin"
echo "For bash/zsh, add to your rc file:"
echo "    export PATH=\"\$HOME/.local/bin:\$PATH\""
echo ""
echo "Then just run:  dork dorks.txt"

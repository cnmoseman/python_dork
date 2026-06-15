#!/usr/bin/env bash
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
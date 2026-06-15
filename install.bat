@echo off
echo === Python Dork Opener - Windows setup (Chromium) ===

where python >nul 2>nul
if %errorlevel% neq 0 (
    echo Python not found. Install from https://www.python.org/downloads/
    echo and check "Add python.exe to PATH", then re-run.
    pause
    exit /b 1
)

where chrome >nul 2>nul
if %errorlevel% neq 0 (
    where chromium >nul 2>nul
    if %errorlevel% neq 0 (
        echo Installing Chromium via winget...
        winget install --id Hibbiki.Chromium -e --silent
    )
)

python -m venv venv
call venv\Scripts\activate.bat
python -m pip install --upgrade pip
pip install selenium

REM --- Install a `dork` launcher command ---
set "INSTALL_DIR=%cd%"
set "LAUNCHER_DIR=%USERPROFILE%\bin"
if not exist "%LAUNCHER_DIR%" mkdir "%LAUNCHER_DIR%"

(
echo @echo off
echo cd /d "%INSTALL_DIR%"
echo call venv\Scripts\activate.bat
echo python dork.py %%*
) > "%LAUNCHER_DIR%\dork.bat"

echo.
echo Setup complete.
echo A 'dork' command was created at %LAUNCHER_DIR%\dork.bat
echo.
echo Add %LAUNCHER_DIR% to your PATH so you can run 'dork' from anywhere:
echo   setx PATH "%%PATH%%;%LAUNCHER_DIR%"
echo Then open a NEW terminal and run:  dork dorks.txt
pause
@echo off
echo === Python Dork Opener - Windows setup (Chromium) ===

REM --- Find a working Python interpreter, bypassing the Store alias trap ---
set "PYTHON_CMD="

py -3 --version >nul 2>nul
if not errorlevel 1 (
    set "PYTHON_CMD=py -3"
    goto :python_found
)

python --version >nul 2>nul
if not errorlevel 1 (
    set "PYTHON_CMD=python"
    goto :python_found
)

echo Python was not found, or the Microsoft Store alias is intercepting it.
echo 1. Install Python from https://www.python.org/downloads/ and check
echo    "Add python.exe to PATH" during install.
echo 2. If Python IS installed but this still fails, disable the Store alias:
echo    Settings ^> Apps ^> Advanced app settings ^> App execution aliases
echo    Turn OFF python.exe and python3.exe.
pause
exit /b 1

:python_found
echo Using Python via: %PYTHON_CMD%

REM --- Check Chromium / Chrome ---
where chrome >nul 2>nul
if %errorlevel% neq 0 (
    where chromium >nul 2>nul
    if %errorlevel% neq 0 (
        echo Chromium not found. Attempting install via winget...
        winget install --id Hibbiki.Chromium -e --silent --accept-package-agreements --accept-source-agreements
        if errorlevel 1 (
            echo Could not confirm a fresh Chromium install via winget.
            echo If Chromium is already installed this is fine. Otherwise install
            echo manually from https://chromium.woolyss.com/ and re-run this script.
        )
    )
)

REM --- Set up project paths ---
set "INSTALL_DIR=%~dp0"
if "%INSTALL_DIR:~-1%"=="\" set "INSTALL_DIR=%INSTALL_DIR:~0,-1%"

REM --- Virtual environment (skip if it already exists) ---
if exist "%INSTALL_DIR%\venv\Scripts\python.exe" (
    echo Virtual environment already exists, skipping creation.
) else (
    %PYTHON_CMD% -m venv "%INSTALL_DIR%\venv"
)

REM --- Install dependencies using the venv's own python.exe directly ---
REM (avoids relying on activate.bat / PATH, which is what breaks across machines)
"%INSTALL_DIR%\venv\Scripts\python.exe" -m pip install --upgrade pip
"%INSTALL_DIR%\venv\Scripts\python.exe" -m pip install selenium

REM --- Create the `dork` launcher command ---
set "LAUNCHER_DIR=%USERPROFILE%\bin"
if not exist "%LAUNCHER_DIR%" mkdir "%LAUNCHER_DIR%"

(
echo @echo off
echo "%INSTALL_DIR%\venv\Scripts\python.exe" "%INSTALL_DIR%\dork.py" %%*
) > "%LAUNCHER_DIR%\dork.bat"

REM --- Add launcher dir to USER PATH safely (no truncation, no duplicates) ---
powershell -NoProfile -Command ^
  "$dir='%LAUNCHER_DIR%';" ^
  "$p=[Environment]::GetEnvironmentVariable('PATH','User');" ^
  "if ($p -notlike '*'+$dir+'*') {" ^
  "  [Environment]::SetEnvironmentVariable('PATH', $p + ';' + $dir, 'User');" ^
  "  Write-Host ('Added ' + $dir + ' to your user PATH.')" ^
  "} else {" ^
  "  Write-Host ($dir + ' already on PATH.')" ^
  "}"

echo.
echo Setup complete.
echo A 'dork' command was created at %LAUNCHER_DIR%\dork.bat
echo.
echo IMPORTANT: open a NEW terminal window for the PATH change to take effect,
echo then run:  dork dorks.txt
pause

@echo off
echo === Python Dork Opener - Windows setup (Chromium) ===

REM --- Check Python ---
where python >nul 2>nul
if %errorlevel% neq 0 (
    echo Python not found. Install from https://www.python.org/downloads/
    echo and check "Add python.exe to PATH", then re-run this script.
    pause
    exit /b 1
)

REM --- Check Chromium / Chrome ---
where chrome >nul 2>nul
if %errorlevel% neq 0 (
    where chromium >nul 2>nul
    if %errorlevel% neq 0 (
        echo Chromium not found. Attempting install via winget...
        winget install --id Hibbiki.Chromium -e --silent --accept-package-agreements --accept-source-agreements
        REM winget exit codes: 0 = installed, -1978335189 = no upgrade/already installed
        if errorlevel 1 (
            echo Could not confirm Chromium via winget. If it is already installed, this is fine.
            echo Otherwise install manually from https://chromium.woolyss.com/ and re-run.
        )
    )
)

REM --- Virtual environment + dependencies ---
python -m venv venv
call venv\Scripts\activate.bat
python -m pip install --upgrade pip
pip install selenium

REM --- Create the `dork` launcher command ---
set "INSTALL_DIR=%cd%"
set "LAUNCHER_DIR=%USERPROFILE%\bin"
if not exist "%LAUNCHER_DIR%" mkdir "%LAUNCHER_DIR%"

(
echo @echo off
echo echo    ______        ______
echo echo   /      \      /      \
echo echo  ^|  ()()  ^|----^|  ()()  ^|
echo echo   \______/      \______/
echo echo         DORK OPENER
echo cd /d "%INSTALL_DIR%"
echo call venv\Scripts\activate.bat
echo python dork.py %%*
) > "%LAUNCHER_DIR%\dork.bat"

REM --- Add launcher dir to USER PATH safely (no truncation, no duplicates) ---
powershell -NoProfile -Command ^
  "$dir='%LAUNCHER_DIR%';" ^
  "$p=[Environment]::GetEnvironmentVariable('PATH','User');" ^
  "if ($p -notlike '*'+$dir+'*') {" ^
  "  [Environment]::SetEnvironmentVariable('PATH', $p + ';' + $dir, 'User');" ^
  "  Write-Host 'Added '+$dir+' to your user PATH.'" ^
  "} else {" ^
  "  Write-Host $dir+' already on PATH.'" ^
  "}"

echo.
echo Setup complete.
echo A 'dork' command was created at %LAUNCHER_DIR%\dork.bat
echo.
echo IMPORTANT: open a NEW terminal window for the PATH change to take effect,
echo then run:  dork dorks.txt
pause

@echo off
setlocal
cd /d "%~dp0"

where node >nul 2>&1
if errorlevel 1 (
  echo Node.js is required. Install Node.js, then run this again.
  pause
  exit /b 1
)

where npm >nul 2>&1
if errorlevel 1 (
  echo npm was not found. Reinstall Node.js with npm enabled, then run this again.
  pause
  exit /b 1
)

if not exist "node_modules\electron\cli.js" (
  echo Installing DesktopApp dependencies...
  call npm install
  if errorlevel 1 (
    echo npm install failed. Review the errors above and try again.
    pause
    exit /b 1
  )
)

if not exist "node_modules\electron\dist\electron.exe" (
  if not exist "node_modules\electron\install.js" (
    echo Electron is missing. Reinstall dependencies with: npm install
    pause
    exit /b 1
  )
  echo Installing Electron runtime...
  node "node_modules\electron\install.js"
  if errorlevel 1 (
    echo Electron runtime installation failed. Review the errors above.
    pause
    exit /b 1
  )
)

if not exist "node_modules\electron\dist\electron.exe" (
  echo Electron runtime was not installed. Try deleting node_modules and running npm install again.
  pause
  exit /b 1
)

echo Starting ScreenExtended Host desktop app...
call npm start
if errorlevel 1 (
  echo.
  echo Host exited with an error.
  pause
)

@echo off
setlocal enabledelayedexpansion

REM Function to report error and continue
:reportError
    echo Error occurred: !errormessage!
    set errorcode=%ERRORLEVEL%

REM Navigate to the main folder
cd ..

REM Backend commands
cd managements

REM Run the backend server in a new command window
start "DJANGO" cmd /k "cd /d %CD% && call .\venv\Scripts\activate && set PRINTER_URL=http://localhost:3000 && set DB_DEFAULT=postgres && python manage.py runserver 0.0.0.0:8000 && pause"

REM Navigate back to the main folder
cd ..

REM Frontend commands
cd frontend

start "FRONT" cmd /k "cd /d %CD% && npm install && if !ERRORLEVEL! neq 0 (echo Failed to install npm packages. && pause && exit /b !ERRORLEVEL!) && npm run serve && pause"

REM Navigate back to the main folder
cd ..

REM Printer service commands
cd printer-v2

start "PRINTER" cmd /k "cd /d %CD% && npm install && if !ERRORLEVEL! neq 0 (echo Failed to install npm packages for printer service. && pause && exit /b !ERRORLEVEL!) && npm run start && pause"

REM Navigate back to the main folder
cd ..

pause
exit /b 0

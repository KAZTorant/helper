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

REM Check if venv directory exists
if not exist venv (
    echo Creating virtual environment...
    python -m venv venv
)

REM Run the backend server in a new command window
start "DJANGO" cmd /k "cd /d %CD% && call .\venv\Scripts\activate && pip install -r requirements.txt && set PRINTER_URL=http://localhost:3000/print && set DB_DEFAULT=postgres && python manage.py runserver 0.0.0.0:8000"

REM Navigate back to the main folder
cd ..

REM Frontend commands
cd frontend

start "FRONT" cmd /k "cd /d %CD% && npm install && npm run serve"

REM Navigate back to the main folder
cd ..

REM Printer service commands
cd printer-v2

start "PRINTER" cmd /k "cd /d %CD% && npm install && npm run start"

REM Navigate back to the main folder
cd ..

pause
exit /b 0

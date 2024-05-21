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
IF NOT EXIST "venv" (
    echo Creating virtual environment...
    python -m venv venv
    if %ERRORLEVEL% neq 0 (
        set errormessage=Failed to create virtual environment.
        call :reportError
    )
) ELSE (
    echo Virtual environment already exists. Skipping creation...
)

REM Activate virtual environment
call .\venv\Scripts\activate
if %ERRORLEVEL% neq 0 (
    set errormessage=Failed to activate virtual environment.
    call :reportError
)

REM Install required Python packages
pip install -r requirements.txt
if %ERRORLEVEL% neq 0 (
    set errormessage=Failed to install Python packages.
    call :reportError
)

REM Set environment variables
set PRINTER_URL=http://localhost:3000
set DB_DEFAULT=postgres

REM Run the backend server in a new command window
start "DJANGO" cmd /k "echo Starting backend server... && python manage.py runserver 0.0.0.0:8000 && pause"
if %ERRORLEVEL% neq 0 (
    set errormessage=Backend server failed to start.
    call :reportError
)

REM Navigate back to the main folder
cd ..

REM Frontend commands
cd frontend
npm install
if %ERRORLEVEL% neq 0 (
    set errormessage=Failed to install npm packages.
    call :reportError
)

REM Run the frontend server in a new command window
start "FRONT" cmd /k "echo Starting frontend server... && npm run serve && pause"
if %ERRORLEVEL% neq 0 (
    set errormessage=Frontend server failed to start.
    call :reportError
)

REM Navigate back to the main folder
cd ..

REM Printer service commands
cd printer-v2
npm install
if %ERRORLEVEL% neq 0 (
    set errormessage=Failed to install npm packages for printer service.
    call :reportError
)

REM Run the printer service in a new command window
start "PRINTER" cmd /k "echo Starting printer service... && npm run start && pause"
if %ERRORLEVEL% neq 0 (
    set errormessage=Printer service failed to start.
    call :reportError
)

REM Navigate back to the main folder
cd ..

pause

exit /b 0

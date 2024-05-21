@echo off
setlocal enabledelayedexpansion

REM Function to terminate all services and exit
:terminate
    echo Terminating all services...
    taskkill /FI "WINDOWTITLE eq DJANGO" /T /F >nul 2>&1
    taskkill /FI "WINDOWTITLE eq FRONT" /T /F >nul 2>&1
    taskkill /FI "WINDOWTITLE eq PRINTER" /T /F >nul 2>&1
    exit /b !errorcode!

REM Navigate to the main folder
cd ..

REM Backend commands
cd managements
IF NOT EXIST "venv" (
    echo Creating virtual environment...
    python -m venv venv
    if %ERRORLEVEL% neq 0 (
        echo Failed to create virtual environment.
        set errorcode=%ERRORLEVEL%
        goto terminate
    )
) ELSE (
    echo Virtual environment already exists. Skipping creation...
)

REM Activate virtual environment
call .\venv\Scripts\activate
if %ERRORLEVEL% neq 0 (
    echo Failed to activate virtual environment.
    set errorcode=%ERRORLEVEL%
    goto terminate
)

REM Install required Python packages
pip install -r requirements.txt
if %ERRORLEVEL% neq 0 (
    echo Failed to install Python packages.
    set errorcode=%ERRORLEVEL%
    goto terminate
)

REM Set environment variables
set PRINTER_URL=http://localhost:3000
set DB_DEFAULT=postgres

REM Run the backend server
start "DJANGO" cmd /k "python manage.py runserver 0.0.0.0:8000"
if %ERRORLEVEL% neq 0 (
    echo Backend server failed to start.
    set errorcode=%ERRORLEVEL%
    goto terminate
)

REM Navigate back to the main folder
cd ..

REM Frontend commands
cd frontend
npm install
if %ERRORLEVEL% neq 0 (
    echo Failed to install npm packages.
    set errorcode=%ERRORLEVEL%
    goto terminate
)

REM Run the frontend server
start "FRONT" cmd /k "npm run serve"
if %ERRORLEVEL% neq 0 (
    echo Frontend server failed to start.
    set errorcode=%ERRORLEVEL%
    goto terminate
)

REM Navigate back to the main folder
cd ..

REM Printer service commands
cd printer-v2
npm install
if %ERRORLEVEL% neq 0 (
    echo Failed to install npm packages for printer service.
    set errorcode=%ERRORLEVEL%
    goto terminate
)

REM Run the printer service
start "PRINTER" cmd /k "npm run start"
if %ERRORLEVEL% neq 0 (
    echo Printer service failed to start.
    set errorcode=%ERRORLEVEL%
    goto terminate
)

REM Navigate back to the main folder
cd ..

pause

exit /b 0

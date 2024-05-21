@echo off
REM Navigate to the main folder
cd ..

REM Backend commands
cd managements
IF NOT EXIST "venv" (
    echo Creating virtual environment...
    python -m venv venv
) ELSE (
    echo Virtual environment already exists. Skipping creation...
)

REM Activate virtual environment
call .\venv\Scripts\activate

REM Install required Python packages
pip install -r requirements.txt

REM Set environment variables
set PRINTER_URL=http://localhost:3000
set DB_DEFAULT=postgres

REM Run the backend server
start "DJANGO" cmd /k "python manage.py runserver 0.0.0.0:8000"

REM Navigate back to the main folder
cd ..

REM Frontend commands
cd frontend
npm install

REM Run the frontend server
start "FROND" cmd /k "npm run serve"

REM Navigate back to the main folder
cd ..

REM Printer service commands
cd printer-v2
npm install

REM Run the printer service
start "PRINTER" cmd /k "npm run start"

REM Navigate back to the main folder
cd ..

pause

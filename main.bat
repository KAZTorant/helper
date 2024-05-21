@echo off
REM Going to main folder
cd ..

REM Backend commands
cd /d "./managements"
IF NOT EXIST "venv" (
    echo Creating virtual environment...
    python -m venv venv
) ELSE (
    echo Virtual environment already exists. Skipping creation...
)
call .\venv\Scripts\activate
pip install -r requirements.txt
set PRINTER_URL=http://localhost:3000
set DB_DEFAULT=postgres
python manage.py runserver 0.0.0.0:8000

REM Going to main folder
cd ..

REM Frontend commands
cd /d "./frontend"
npm install
npm run serve

REM Going to main folder
cd ..


REM Printer commands
cd /d "./printer-v2"
npm install
npm run start

REM Going to main folder
cd ..

pause

@echo off
echo ========================================
echo Connector Use Case Matrix - Starting
echo ========================================
echo.

if not exist "venv\" (
    echo ERROR: Virtual environment not found
    echo Please run setup.bat first
    pause
    exit /b 1
)

if not exist "ConnUCMatrix.xlsx" (
    echo WARNING: ConnUCMatrix.xlsx not found in current directory
    echo Please place your Excel file here
    echo.
)

echo Activating virtual environment...
call venv\Scripts\activate.bat

echo Starting application...
echo.
echo ========================================
echo Application running at http://localhost:5000
echo Press Ctrl+C to stop
echo ========================================
echo.

python app.py

pause

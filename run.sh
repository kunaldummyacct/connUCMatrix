#!/bin/bash

echo "========================================"
echo "Connector Use Case Matrix - Starting"
echo "========================================"
echo ""

if [ ! -d "venv" ]; then
    echo "ERROR: Virtual environment not found"
    echo "Please run ./setup.sh first"
    exit 1
fi

if [ ! -f "ConnUCMatrix.xlsx" ]; then
    echo "WARNING: ConnUCMatrix.xlsx not found in current directory"
    echo "Please place your Excel file here"
    echo ""
fi

echo "Activating virtual environment..."
source venv/bin/activate

echo "Starting application..."
echo ""
echo "========================================"
echo "Application running at http://localhost:5000"
echo "Press Ctrl+C to stop"
echo "========================================"
echo ""

python app.py

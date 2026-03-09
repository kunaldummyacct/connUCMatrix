# Connector Use Case Matrix - Web Dashboard

A web-based dashboard for viewing and editing Excel connector use case matrices with password protection, filtering, and auto-save capabilities.

## Features

- 🔐 Password-protected access (default: `admin123`)
- 📊 View and edit Excel data with 3-level headers and merged cells
- 🔍 Filter any column with real-time search
- 💾 Auto-save after 3 seconds of inactivity
- ⌨️ Keyboard shortcuts (Ctrl/Cmd+S to save)
- 🎨 Modern, colorful UI with gradient themes
- 📝 Smart Y/N/NA dropdowns for boolean columns
- 🔄 Reset unsaved changes
- 📱 Responsive design with frozen headers and columns

## Requirements

- Python 3.8 or higher
- Excel file named `ConnUCMatrix.xlsx` in the same directory

## Installation & Setup

### Windows

1. Double-click `setup.bat` to install dependencies
2. Double-click `run.bat` to start the application
3. Open your browser to `http://localhost:5000`

### Mac/Linux

1. Run `chmod +x setup.sh run.sh` to make scripts executable
2. Run `./setup.sh` to install dependencies
3. Run `./run.sh` to start the application
4. Open your browser to `http://localhost:5000`

### Manual Setup

```bash
# Create virtual environment
python -m venv venv

# Activate virtual environment
# Windows:
venv\Scripts\activate
# Mac/Linux:
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Run application
python app.py
```

## Usage

1. **Login**: Enter password (default: `admin123`)
2. **View Data**: Browse the table with frozen headers
3. **Edit Cells**: Click any cell to edit
   - Text columns: Use textarea
   - Y/N columns: Use dropdown (Y, N, NA, or empty)
4. **Filter**: Type in filter boxes below column headers
5. **Save**: Click "Save" button or press Ctrl/Cmd+S
6. **Reset**: Click "Reset Changes" to discard unsaved edits

## Configuration

### Change Password

Edit `app.py` and modify:
```python
ADMIN_PASSWORD = 'your_new_password'
```

### Change Excel File Location

Edit `app.py` and modify:
```python
EXCEL_FILE = os.path.expanduser('~/your_file.xlsx')
```

### Change Port

Edit `app.py` and modify the last line:
```python
app.run(debug=True, port=5000)  # Change 5000 to your desired port
```

## File Structure

```
connUCMatrix/
├── app.py                  # Flask backend
├── templates/
│   ├── index.html         # Main dashboard
│   └── login.html         # Login page
├── requirements.txt       # Python dependencies
├── ConnUCMatrix.xlsx      # Your Excel file (place here)
├── setup.bat             # Windows setup script
├── setup.sh              # Mac/Linux setup script
├── run.bat               # Windows run script
├── run.sh                # Mac/Linux run script
└── README.md             # This file
```

## Troubleshooting

### Port Already in Use
If you see "Address already in use", either:
- Stop the existing process
- Change the port in `app.py`

### Excel File Not Found
Ensure `ConnUCMatrix.xlsx` is in the same directory as `app.py`

### Dependencies Installation Failed
Try upgrading pip first:
```bash
python -m pip install --upgrade pip
```

### Browser Shows "Connection Refused"
Make sure the Flask app is running (you should see "Running on http://127.0.0.1:5000")

## Security Notes

- This is designed for local use only
- Default password should be changed for production use
- Do not expose to the internet without proper security measures
- Session secret key should be changed in production

## License

MIT License - Feel free to modify and distribute

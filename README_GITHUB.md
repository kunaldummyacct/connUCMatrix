# Connector Use Case Matrix Editor

A web-based Excel editor for viewing and editing connector use case matrices with password protection, filtering, and modern UI.

## Features

- 🔐 Password-protected access (default: `admin123`)
- 📊 Excel file editing with 3-row header support
- 🔍 Column filtering with debounced search
- ✏️ Click-to-edit cells with smart Y/N dropdowns
- ➕ Add and delete rows
- 💾 Manual save with Ctrl/Cmd+S shortcut
- 🎨 Modern gradient UI with frozen headers and first column
- 📱 Responsive table layout

## Quick Start

### Prerequisites
- Python 3.8 or higher
- Your Excel file named `ConnUCMatrix.xlsx`

### Installation

**Windows:**
1. Clone or download this repository
2. Place your `ConnUCMatrix.xlsx` file in the project folder
3. Double-click `setup.bat` (first time only)
4. Double-click `run.bat` to start
5. Open http://localhost:5000 in your browser
6. Login with password: `admin123`

**Mac/Linux:**
1. Clone or download this repository
2. Place your `ConnUCMatrix.xlsx` file in the project folder
3. Run `./setup.sh` (first time only)
4. Run `./run.sh` to start
5. Open http://localhost:5000 in your browser
6. Login with password: `admin123`

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

# Run the application
python app.py
```

## Configuration

Edit `app.py` to customize:

```python
ADMIN_PASSWORD = 'admin123'  # Change the password
app.run(debug=True, port=5000)  # Change the port
```

## Excel File Requirements

- File must be named `ConnUCMatrix.xlsx`
- Must have 3 header rows
- Place in the same directory as `app.py`

## Usage

### Editing Cells
- Click any cell to edit
- Y/N columns automatically show dropdowns
- Text columns show textarea for multi-line editing
- Changes are highlighted in blue

### Saving Changes
- Click "Save Changes" button
- Or press Ctrl/Cmd+S
- Changes are saved to the Excel file

### Adding/Deleting Rows
- Click "➕ Add Row" to add a new empty row
- Click "🗑️ Delete" on any row to remove it
- Changes are tracked until saved

### Filtering
- Type in filter boxes below headers
- Filters apply with 300ms delay
- Click "Clear Filters" to reset

### Reset Changes
- Click "Reset Changes" to undo all unsaved edits
- Confirmation required

## Project Structure

```
connUCMatrix/
├── app.py                  # Flask backend
├── templates/
│   ├── index.html         # Main dashboard
│   └── login.html         # Login page
├── requirements.txt       # Python dependencies
├── README.md             # This file
├── setup.bat             # Windows setup script
├── setup.sh              # Mac/Linux setup script
├── run.bat               # Windows run script
├── run.sh                # Mac/Linux run script
└── ConnUCMatrix.xlsx     # Your Excel file (not included)
```

## Dependencies

- Flask - Web framework
- pandas - Excel data manipulation
- openpyxl - Excel file reading/writing with merge support

## Security Notes

- Change the default password in production
- The app runs on localhost by default
- Session secret key regenerates on restart
- Not recommended for public internet deployment without additional security

## Troubleshooting

### Excel file not found
- Ensure `ConnUCMatrix.xlsx` is in the same directory as `app.py`
- Check file name spelling (case-sensitive on Mac/Linux)

### Port already in use
- Change the port in `app.py`: `app.run(debug=True, port=5001)`

### Virtual environment issues
- Delete `venv` folder and run setup script again

### Changes not saving
- Check file permissions on `ConnUCMatrix.xlsx`
- Ensure Excel file is not open in another program

## License

This project is provided as-is for internal use.

## Support

For issues or questions, please create an issue in the GitHub repository.

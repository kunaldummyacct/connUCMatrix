# Distribution Package Created

## Package Location
`/home/kunalshivalkar/connUCMatrix/dist/`

## Files Available
1. **connUCMatrix-portable.zip** - For Windows and Mac users
2. **connUCMatrix-portable.tar.gz** - Alternative for Linux/Mac users

## What's Inside the Package
```
connUCMatrix-portable/
├── app.py                 # Flask application
├── requirements.txt       # Python dependencies
├── README.md             # Full documentation
├── QUICKSTART.txt        # Quick start guide
├── setup.bat             # Windows setup script
├── setup.sh              # Mac/Linux setup script
├── run.bat               # Windows run script
├── run.sh                # Mac/Linux run script
└── templates/
    ├── index.html        # Main dashboard
    └── login.html        # Login page
```

## Distribution Instructions

### For Windows Users:
1. Send them `connUCMatrix-portable.zip`
2. They extract it
3. They copy their `ConnUCMatrix.xlsx` into the extracted folder
4. They double-click `setup.bat` (first time only)
5. They double-click `run.bat` to start
6. They open browser to http://localhost:5000
7. Login password: `admin123`

### For Mac Users:
1. Send them `connUCMatrix-portable.zip` or `.tar.gz`
2. They extract it
3. They copy their `ConnUCMatrix.xlsx` into the extracted folder
4. They open Terminal, navigate to the folder
5. They run `./setup.sh` (first time only)
6. They run `./run.sh` to start
7. They open browser to http://localhost:5000
8. Login password: `admin123`

## Requirements
- Python 3.8 or higher (must be installed on target machine)
- Internet connection (for initial setup to download dependencies)
- Excel file named `ConnUCMatrix.xlsx`

## Notes
- The package is portable - no installation needed
- Each user needs to run setup once to create their virtual environment
- The Excel file is NOT included - users must provide their own
- Default password is `admin123` - can be changed in app.py
- Runs locally on port 5000

## Customization
Users can customize by editing `app.py`:
- Change password: `ADMIN_PASSWORD = 'new_password'`
- Change port: `app.run(debug=True, port=5000)`
- Change Excel file path: `EXCEL_FILE = 'path/to/file.xlsx'`

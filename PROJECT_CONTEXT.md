# Connector Use Case Matrix - Project Context

## Project Overview
A web-based Excel editor for viewing and editing connector use case matrices with password protection, filtering, auto-save, and modern UI. Built with Python Flask backend + vanilla HTML/JS frontend.

## Current Status: ✅ COMPLETE & PACKAGED

Distribution package ready at: `/home/kunalshivalkar/connUCMatrix/dist/connUCMatrix-portable.zip`

## Project Structure
```
/home/kunalshivalkar/connUCMatrix/
├── app.py                      # Flask backend (FINAL VERSION)
├── templates/
│   ├── index.html             # Main dashboard (checkpointlocal state)
│   └── login.html             # Login page
├── requirements.txt           # flask, pandas, openpyxl
├── README.md                  # Full documentation
├── QUICKSTART.txt            # Quick start guide
├── DISTRIBUTION.md           # Distribution instructions
├── setup.bat                 # Windows setup script
├── setup.sh                  # Mac/Linux setup script (executable)
├── run.bat                   # Windows run script
├── run.sh                    # Mac/Linux run script (executable)
├── package.sh                # Packaging script (executable)
├── venv/                     # Virtual environment
└── dist/
    ├── connUCMatrix-portable.zip     # FINAL PACKAGE (Windows/Mac)
    └── connUCMatrix-portable.tar.gz  # Alternative (Linux)
```

## Key Features Implemented

### 1. Authentication
- Session-based password protection
- Default password: `admin123`
- Login page with gradient UI

### 2. Excel Data Display
- Reads `ConnUCMatrix.xlsx` from same directory as app.py
- 3 header rows with merged cell support (colspan/rowspan)
- All columns displayed as-is (no column removal)
- Frozen headers (rows 1-3) and first column
- Text wrapping in cells

### 3. Editing
- Click any cell to edit (yellow highlight while editing)
- Smart detection: Y/N columns get dropdowns (Y, N, NA, empty), text columns get textareas
- Blue highlight for unsaved changes
- Auto-save after 3 seconds of inactivity
- Manual save with Ctrl/Cmd+S keyboard shortcut
- Reset Changes button with confirmation

### 4. Filtering
- Filter row below header row 3
- Debounced search (300ms delay)
- Clear Filters button
- Stats display: Total rows, Filtered rows, Unsaved changes

### 5. UI/UX
- Gradient purple/violet theme throughout
- Color-coded header rows:
  - Row 1: Dark purple gradient (#667eea→#764ba2)
  - Row 2: Medium purple gradient (#818cf8→#9333ea)
  - Row 3: Light purple gradient (#a78bfa→#c084fc)
- Compact layout: header + controls bar + large table
- Table height: `calc(100vh - 180px)` for maximum screen usage
- Smooth scrolling with gradient scrollbar
- Last saved timestamp display

## Technical Implementation

### Backend (app.py)
```python
# Key configuration
EXCEL_FILE = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'ConnUCMatrix.xlsx')
ADMIN_PASSWORD = 'admin123'

# Reads Excel with openpyxl (merged cells) + pandas (data)
# Preserves all 3 header rows when saving
# File existence check with helpful error message
```

**Critical Code - Reading merged cells:**
```python
from openpyxl import load_workbook

wb = load_workbook(EXCEL_FILE)
ws = wb.active

# Get merged cell ranges
merged_cells = [{
    'min_row': m.min_row, 'max_row': m.max_row,
    'min_col': m.min_col, 'max_col': m.max_col
} for m in ws.merged_cells.ranges]

# Read headers directly from openpyxl (rows 1-3)
headers = []
for row_idx in range(1, 4):
    row_data = [ws.cell(row=row_idx, column=col_idx).value or '' 
                for col_idx in range(1, ws.max_column + 1)]
    headers.append(row_data)

# Read data with pandas (skip first 3 header rows)
data_df = pd.read_excel(EXCEL_FILE, header=2)
```

### Frontend (templates/index.html)
**Y/N Column Auto-Detection:**
```javascript
// Checks first 50 rows
const ynColumns = new Set();
for (let colIdx = 0; colIdx < columns.length; colIdx++) {
    let hasYN = false, hasOther = false;
    for (let rowIdx = 0; rowIdx < Math.min(data.length, 50); rowIdx++) {
        const val = String(data[rowIdx][colIdx]).trim().toUpperCase();
        if (val === 'Y' || val === 'N' || val === 'NA' || val === '') hasYN = true;
        else { hasOther = true; break; }
    }
    if (hasYN && !hasOther) ynColumns.add(colIdx);
}
```

**Merged Cell Rendering:**
```javascript
// Skip cells covered by merged cells
const isCovered = merged_cells.some(m => {
    const rowInRange = (i + 1) >= m.min_row && (i + 1) <= m.max_row;
    const colInRange = (j + 1) >= m.min_col && (j + 1) <= m.max_col;
    const isNotStart = !((i + 1) === m.min_row && (j + 1) === m.min_col);
    return rowInRange && colInRange && isNotStart;
});
if (isCovered) continue;
```

**Frozen Column Styling:**
```css
.frozen-col {
    position: sticky;
    left: 0;
    z-index: 20;
    background: white;
    border-right: 3px solid #667eea;
}
```

## Dependencies
```
flask
pandas
openpyxl
```

## Checkpoints Created
1. **checkpoint1** - Base functionality with modern UI
2. **checkpointlocal** - Enhanced with colors, Y/N dropdowns, compact layout (CURRENT STATE)

## Recent Fixes
**Latest (2026-03-05):** Fixed Excel file path for Windows compatibility
- Changed from `~/ConnUCMatrix.xlsx` to same directory as `app.py`
- Added file existence check with helpful error message
- Recreated distribution package with fix

## Distribution Package
**Location:** `/home/kunalshivalkar/connUCMatrix/dist/connUCMatrix-portable.zip`

**Contents:**
- app.py, templates/, requirements.txt
- Setup scripts (setup.bat, setup.sh)
- Run scripts (run.bat, run.sh)
- Documentation (README.md, QUICKSTART.txt)

**User Instructions:**
1. Extract zip
2. Place `ConnUCMatrix.xlsx` in extracted folder (same directory as app.py)
3. Run setup script once (setup.bat for Windows, ./setup.sh for Mac/Linux)
4. Run application (run.bat for Windows, ./run.sh for Mac/Linux)
5. Open http://localhost:5000
6. Login with password: admin123

## Configuration Options
Users can customize by editing `app.py`:
- Password: `ADMIN_PASSWORD = 'admin123'`
- Port: `app.run(debug=True, port=5000)`
- Excel file: `EXCEL_FILE = os.path.join(...)`

## Known Requirements
- Python 3.8+ must be installed on target machine
- Internet connection for initial setup (pip install)
- Excel file must be named `ConnUCMatrix.xlsx`
- Excel file must have 3 header rows (rows 1-2 can have merged cells)

## Testing Status
- ✅ Tested on Linux (development machine)
- ✅ Windows path issue identified and fixed
- ⏳ Needs testing: Fresh install on Windows
- ⏳ Needs testing: Fresh install on Mac

## Future Enhancement Ideas (Not Implemented)
- Export filtered data
- Column sorting
- Row numbers
- Cell validation
- Audit trail/history
- PyInstaller executable (no Python required)

## How to Continue This Project

### To Resume Development:
```bash
cd /home/kunalshivalkar/connUCMatrix
source venv/bin/activate
python app.py
# Open http://localhost:5000
```

### To Make Changes:
1. Edit `app.py` for backend changes
2. Edit `templates/index.html` for frontend changes
3. Test locally
4. Run `./package.sh` to recreate distribution package
5. New package will be in `dist/` folder

### To Restore Checkpoints:
- Checkpoint files are in project root (if created)
- Use git or manual backup/restore

## Important Notes
- Excel file path now uses script directory (Windows compatible)
- All scripts are executable (chmod +x applied)
- Package includes both .zip (Windows/Mac) and .tar.gz (Linux)
- Virtual environment is NOT included in package (created by setup scripts)
- Session secret key uses `os.urandom(24)` - regenerates on restart

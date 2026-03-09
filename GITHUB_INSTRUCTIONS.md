# How to Upload to GitHub

## Step 1: Initialize Git Repository

```bash
cd /home/kunalshivalkar/connUCMatrix
git init
git add .
git commit -m "Initial commit: Connector Use Case Matrix Editor"
```

## Step 2: Create GitHub Repository

1. Go to https://github.com
2. Click the "+" icon in the top right
3. Select "New repository"
4. Fill in:
   - **Repository name**: `connUCMatrix` (or your preferred name)
   - **Description**: "Web-based Excel editor for connector use case matrices"
   - **Visibility**: Choose Public or Private
   - **DO NOT** initialize with README, .gitignore, or license (we already have these)
5. Click "Create repository"

## Step 3: Push to GitHub

GitHub will show you commands. Use these:

```bash
cd /home/kunalshivalkar/connUCMatrix
git remote add origin https://github.com/YOUR_USERNAME/connUCMatrix.git
git branch -M main
git push -u origin main
```

Replace `YOUR_USERNAME` with your GitHub username.

## Step 4: Verify

1. Refresh your GitHub repository page
2. You should see all files except:
   - `venv/` folder
   - `*.xlsx` files (except sample)
   - Checkpoint files (`.Edit1`, `.Edit2`, `.Edit3`)
   - `dist/` folder

## Alternative: Using GitHub Desktop

1. Download GitHub Desktop: https://desktop.github.com/
2. Open GitHub Desktop
3. Click "Add" → "Add Existing Repository"
4. Browse to `/home/kunalshivalkar/connUCMatrix`
5. Click "Publish repository"
6. Choose name, description, and visibility
7. Click "Publish repository"

## What Gets Uploaded

✅ **Included:**
- `app.py`
- `templates/` folder
- `requirements.txt`
- `README.md`
- Setup and run scripts
- `.gitignore`

❌ **Excluded (by .gitignore):**
- `venv/` - Virtual environment
- `*.xlsx` - Excel files (users provide their own)
- Checkpoint backups
- `dist/` - Distribution packages
- IDE and OS files

## After Upload

Share the repository URL with others:
```
https://github.com/YOUR_USERNAME/connUCMatrix
```

They can clone it with:
```bash
git clone https://github.com/YOUR_USERNAME/connUCMatrix.git
cd connUCMatrix
# Place their ConnUCMatrix.xlsx file here
./setup.sh  # or setup.bat on Windows
./run.sh    # or run.bat on Windows
```

## Updating the Repository

After making changes:

```bash
git add .
git commit -m "Description of changes"
git push
```

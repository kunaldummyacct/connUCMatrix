# Security Configuration

## Admin Password Setup

The admin password can be configured in two ways:

### Option 1: Environment Variable (Recommended)

1. Create a `.env` file in the project root:
```bash
cp .env.example .env
```

2. Edit `.env` and set your password:
```
ADMIN_PASSWORD=your_secure_password_here
```

3. Run the application normally:
```bash
./run.sh
```

The `.env` file is automatically excluded from git (listed in `.gitignore`).

### Option 2: Direct Edit (Not Recommended)

Edit `app.py` and change:
```python
ADMIN_PASSWORD = os.environ.get('ADMIN_PASSWORD', 'admin123')
```

Replace `'admin123'` with your password. **Warning:** This will be visible in the code.

## Setting Environment Variable Manually

### Linux/Mac:
```bash
export ADMIN_PASSWORD='your_secure_password'
python app.py
```

### Windows (Command Prompt):
```cmd
set ADMIN_PASSWORD=your_secure_password
python app.py
```

### Windows (PowerShell):
```powershell
$env:ADMIN_PASSWORD='your_secure_password'
python app.py
```

## Password Best Practices

- Use at least 12 characters
- Mix uppercase, lowercase, numbers, and symbols
- Don't share the password in documentation or git
- Change the default password immediately
- Use different passwords for different environments (dev/prod)

## Default Password

If no environment variable is set, the default password is `admin123`.
**Change this immediately for production use!**

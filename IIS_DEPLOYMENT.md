# IIS Deployment Guide for ConnUCMatrix

## Prerequisites

### 1. Install IIS with Required Features
Open PowerShell as Administrator and run:
```powershell
Install-WindowsFeature -name Web-Server -IncludeManagementTools
Install-WindowsFeature -name Web-CGI
Install-WindowsFeature -name Web-Http-Redirect
```

### 2. Install Python
- Download Python 3.11+ from https://www.python.org/downloads/
- **Important**: Check "Add Python to PATH" during installation
- Verify: `python --version`

### 3. Install HttpPlatformHandler
- Download from: https://www.iis.net/downloads/microsoft/httpplatformhandler
- Or direct link: https://go.microsoft.com/fwlink/?LinkId=690721
- Run installer: `HttpPlatformHandler_amd64.msi`

## Deployment Steps

### Step 1: Prepare Application Directory
```powershell
# Create application directory
New-Item -ItemType Directory -Path "C:\inetpub\wwwroot\connUCMatrix"

# Copy application files to this directory
# - app.py
# - templates/
# - requirements.txt
# - web.config
# - ConnUCMatrix.xlsx

# Create logs directory
New-Item -ItemType Directory -Path "C:\inetpub\wwwroot\connUCMatrix\logs"
```

### Step 2: Set Up Python Virtual Environment
```powershell
cd C:\inetpub\wwwroot\connUCMatrix

# Create virtual environment
python -m venv venv

# Activate and install dependencies
.\venv\Scripts\activate
python -m pip install --upgrade pip
pip install --only-binary :all: -r requirements.txt
```

### Step 3: Configure File Permissions
```powershell
# Grant IIS_IUSRS read/write access to app directory
icacls "C:\inetpub\wwwroot\connUCMatrix" /grant "IIS_IUSRS:(OI)(CI)M" /T

# Ensure Excel file is writable
icacls "C:\inetpub\wwwroot\connUCMatrix\ConnUCMatrix.xlsx" /grant "IIS_IUSRS:M"
```

### Step 4: Create IIS Application
```powershell
# Import IIS module
Import-Module WebAdministration

# Create application pool
New-WebAppPool -Name "ConnUCMatrixPool"
Set-ItemProperty IIS:\AppPools\ConnUCMatrixPool -Name managedRuntimeVersion -Value ""

# Create IIS application
New-WebApplication -Name "connucmatrix" -Site "Default Web Site" -PhysicalPath "C:\inetpub\wwwroot\connUCMatrix" -ApplicationPool "ConnUCMatrixPool"
```

### Step 5: Update web.config
Edit `C:\inetpub\wwwroot\connUCMatrix\web.config`:
- Update `processPath` if Python is in different location
- Change `ADMIN_PASSWORD` environment variable
- Adjust paths if using different directory

### Step 6: Start Application
```powershell
# Restart IIS
iisreset

# Or restart just the app pool
Restart-WebAppPool -Name "ConnUCMatrixPool"
```

### Step 7: Test
Open browser and navigate to:
- `http://localhost/connucmatrix`
- Or `http://your-server-name/connucmatrix`

## Configuration Options

### Change Admin Password
Edit `web.config`, find:
```xml
<environmentVariable name="ADMIN_PASSWORD" value="admin123" />
```
Change `value` to your desired password.

### Enable HTTPS
1. Obtain SSL certificate
2. Bind certificate to IIS site:
```powershell
New-WebBinding -Name "Default Web Site" -Protocol https -Port 443
```
3. Configure certificate in IIS Manager

### Custom Port (Standalone)
To run on custom port instead of under Default Web Site:
```powershell
# Create new site
New-Website -Name "ConnUCMatrix" -Port 8080 -PhysicalPath "C:\inetpub\wwwroot\connUCMatrix" -ApplicationPool "ConnUCMatrixPool"
```

## Troubleshooting

### Check Logs
```powershell
# View Python logs
Get-Content C:\inetpub\wwwroot\connUCMatrix\logs\python.log -Tail 50

# View IIS logs
Get-Content C:\inetpub\logs\LogFiles\W3SVC1\*.log -Tail 50
```

### Common Issues

**1. HTTP 500 Error**
- Check Python is installed and in PATH
- Verify virtual environment has all dependencies
- Check file permissions (IIS_IUSRS needs access)
- Review logs in `logs\python.log`

**2. Application Won't Start**
- Verify HttpPlatformHandler is installed
- Check `processPath` in web.config points to correct Python
- Ensure waitress is installed: `.\venv\Scripts\pip list | findstr waitress`

**3. Excel File Not Found**
- Verify `ConnUCMatrix.xlsx` is in application root
- Check file permissions

**4. Changes Not Saving**
- Verify IIS_IUSRS has write permission to Excel file
- Check disk space

### Restart Application
```powershell
Restart-WebAppPool -Name "ConnUCMatrixPool"
```

## Maintenance

### Update Application
```powershell
cd C:\inetpub\wwwroot\connUCMatrix

# Stop app pool
Stop-WebAppPool -Name "ConnUCMatrixPool"

# Update files (copy new app.py, templates, etc.)

# Update dependencies if needed
.\venv\Scripts\activate
pip install -r requirements.txt

# Start app pool
Start-WebAppPool -Name "ConnUCMatrixPool"
```

### Backup Excel File
```powershell
# Create scheduled task to backup Excel file
$action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-Command Copy-Item C:\inetpub\wwwroot\connUCMatrix\ConnUCMatrix.xlsx C:\Backups\ConnUCMatrix_$(Get-Date -Format 'yyyyMMdd_HHmmss').xlsx"
$trigger = New-ScheduledTaskTrigger -Daily -At 2am
Register-ScheduledTask -TaskName "BackupConnUCMatrix" -Action $action -Trigger $trigger
```

## Security Recommendations

1. **Change default password** in web.config
2. **Enable HTTPS** for production
3. **Restrict access** using IIS Authorization Rules
4. **Regular backups** of Excel file
5. **Monitor logs** for suspicious activity
6. **Keep Python and dependencies updated**

## Windows Authentication (Optional)

To use Windows/AD authentication instead of password:

1. Enable Windows Authentication in IIS:
```powershell
Install-WindowsFeature Web-Windows-Auth
Set-WebConfigurationProperty -Filter "/system.webServer/security/authentication/windowsAuthentication" -Name enabled -Value true -PSPath "IIS:\Sites\Default Web Site\connucmatrix"
Set-WebConfigurationProperty -Filter "/system.webServer/security/authentication/anonymousAuthentication" -Name enabled -Value false -PSPath "IIS:\Sites\Default Web Site\connucmatrix"
```

2. Modify `app.py` to use Windows authentication (requires code changes)

## Support

For issues:
1. Check logs in `logs\python.log`
2. Verify IIS configuration in IIS Manager
3. Test Python app directly: `python app.py` (should run on port 5000)

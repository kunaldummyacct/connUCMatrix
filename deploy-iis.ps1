# ConnUCMatrix IIS Deployment Script
# Run as Administrator

param(
    [string]$AppPath = "C:\inetpub\wwwroot\connUCMatrix",
    [string]$AppPoolName = "ConnUCMatrixPool",
    [string]$SiteName = "Default Web Site",
    [string]$AppName = "connucmatrix",
    [string]$AdminPassword = "admin123"
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "ConnUCMatrix IIS Deployment" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if running as Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "ERROR: This script must be run as Administrator" -ForegroundColor Red
    exit 1
}

# Check Python installation
Write-Host "Checking Python installation..." -ForegroundColor Yellow
try {
    $pythonVersion = python --version 2>&1
    Write-Host "Found: $pythonVersion" -ForegroundColor Green
} catch {
    Write-Host "ERROR: Python not found. Please install Python 3.11+ and add to PATH" -ForegroundColor Red
    exit 1
}

# Check IIS installation
Write-Host "Checking IIS installation..." -ForegroundColor Yellow
$iis = Get-WindowsFeature -Name Web-Server
if (-not $iis.Installed) {
    Write-Host "IIS not installed. Installing..." -ForegroundColor Yellow
    Install-WindowsFeature -name Web-Server -IncludeManagementTools
    Install-WindowsFeature -name Web-CGI
} else {
    Write-Host "IIS is installed" -ForegroundColor Green
}

# Create application directory
Write-Host "Creating application directory..." -ForegroundColor Yellow
if (-not (Test-Path $AppPath)) {
    New-Item -ItemType Directory -Path $AppPath -Force | Out-Null
}
New-Item -ItemType Directory -Path "$AppPath\logs" -Force | Out-Null
Write-Host "Directory created: $AppPath" -ForegroundColor Green

# Copy files (assumes script is run from source directory)
Write-Host "Copying application files..." -ForegroundColor Yellow
$sourceDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Copy-Item "$sourceDir\app.py" -Destination $AppPath -Force
Copy-Item "$sourceDir\web.config" -Destination $AppPath -Force
Copy-Item "$sourceDir\requirements.txt" -Destination $AppPath -Force
Copy-Item "$sourceDir\templates" -Destination $AppPath -Recurse -Force
if (Test-Path "$sourceDir\ConnUCMatrix.xlsx") {
    Copy-Item "$sourceDir\ConnUCMatrix.xlsx" -Destination $AppPath -Force
    Write-Host "Excel file copied" -ForegroundColor Green
} else {
    Write-Host "WARNING: ConnUCMatrix.xlsx not found. Please copy it manually to $AppPath" -ForegroundColor Yellow
}

# Update web.config with custom password
Write-Host "Updating web.config..." -ForegroundColor Yellow
$webConfigPath = "$AppPath\web.config"
$webConfig = Get-Content $webConfigPath -Raw
$webConfig = $webConfig -replace 'value="admin123"', "value=`"$AdminPassword`""
$webConfig = $webConfig -replace '%SystemDrive%\\inetpub\\wwwroot\\connUCMatrix', $AppPath.Replace('\', '\\')
Set-Content -Path $webConfigPath -Value $webConfig
Write-Host "web.config updated" -ForegroundColor Green

# Create virtual environment
Write-Host "Creating Python virtual environment..." -ForegroundColor Yellow
Push-Location $AppPath
python -m venv venv
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Failed to create virtual environment" -ForegroundColor Red
    Pop-Location
    exit 1
}

# Install dependencies
Write-Host "Installing Python dependencies..." -ForegroundColor Yellow
& "$AppPath\venv\Scripts\python.exe" -m pip install --upgrade pip --quiet
& "$AppPath\venv\Scripts\pip.exe" install --only-binary :all: -r requirements.txt --quiet
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Failed to install dependencies" -ForegroundColor Red
    Pop-Location
    exit 1
}
Write-Host "Dependencies installed" -ForegroundColor Green
Pop-Location

# Set file permissions
Write-Host "Setting file permissions..." -ForegroundColor Yellow
icacls $AppPath /grant "IIS_IUSRS:(OI)(CI)M" /T /Q
Write-Host "Permissions set" -ForegroundColor Green

# Import IIS module
Import-Module WebAdministration

# Create application pool
Write-Host "Creating IIS application pool..." -ForegroundColor Yellow
if (Test-Path "IIS:\AppPools\$AppPoolName") {
    Remove-WebAppPool -Name $AppPoolName
}
New-WebAppPool -Name $AppPoolName | Out-Null
Set-ItemProperty "IIS:\AppPools\$AppPoolName" -Name managedRuntimeVersion -Value ""
Set-ItemProperty "IIS:\AppPools\$AppPoolName" -Name startMode -Value "AlwaysRunning"
Write-Host "Application pool created: $AppPoolName" -ForegroundColor Green

# Create IIS application
Write-Host "Creating IIS application..." -ForegroundColor Yellow
$appPath = "IIS:\Sites\$SiteName\$AppName"
if (Test-Path $appPath) {
    Remove-WebApplication -Name $AppName -Site $SiteName
}
New-WebApplication -Name $AppName -Site $SiteName -PhysicalPath $AppPath -ApplicationPool $AppPoolName | Out-Null
Write-Host "Application created: $AppName" -ForegroundColor Green

# Restart IIS
Write-Host "Restarting IIS..." -ForegroundColor Yellow
iisreset /noforce | Out-Null
Write-Host "IIS restarted" -ForegroundColor Green

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Deployment Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Application URL: http://localhost/$AppName" -ForegroundColor Yellow
Write-Host "Admin Password: $AdminPassword" -ForegroundColor Yellow
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Ensure ConnUCMatrix.xlsx is in $AppPath" -ForegroundColor White
Write-Host "2. Open browser and navigate to http://localhost/$AppName" -ForegroundColor White
Write-Host "3. Check logs at $AppPath\logs\python.log if issues occur" -ForegroundColor White
Write-Host ""

# Bus Booking App - Setup Script for Windows
# Run this in PowerShell to quickly set up the backend

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Bus Booking App - Backend Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check Python
Write-Host "Checking Python installation..." -ForegroundColor Yellow
$pythonVersion = python --version 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Python found: $pythonVersion" -ForegroundColor Green
} else {
    Write-Host "✗ Python not found! Please install Python 3.8 or higher" -ForegroundColor Red
    exit
}

# Create virtual environment
Write-Host ""
Write-Host "Creating virtual environment..." -ForegroundColor Yellow
python -m venv venv
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Virtual environment created" -ForegroundColor Green
} else {
    Write-Host "✗ Failed to create virtual environment" -ForegroundColor Red
    exit
}

# Activate virtual environment
Write-Host ""
Write-Host "Activating virtual environment..." -ForegroundColor Yellow
& .\venv\Scripts\Activate.ps1

# Install dependencies
Write-Host ""
Write-Host "Installing dependencies (this may take a few minutes)..." -ForegroundColor Yellow
pip install -r requirements.txt
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Dependencies installed successfully" -ForegroundColor Green
} else {
    Write-Host "✗ Failed to install dependencies" -ForegroundColor Red
    exit
}

# Check for .env file
Write-Host ""
if (Test-Path .env) {
    Write-Host "✓ .env file exists" -ForegroundColor Green
} else {
    Write-Host "! Creating .env file from .env.example..." -ForegroundColor Yellow
    Copy-Item .env.example .env
    Write-Host ""
    Write-Host "================================================" -ForegroundColor Red
    Write-Host "  IMPORTANT: Edit .env file with your Supabase credentials!" -ForegroundColor Red
    Write-Host "================================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "1. Go to https://supabase.com" -ForegroundColor Cyan
    Write-Host "2. Create a project (if you haven't already)" -ForegroundColor Cyan
    Write-Host "3. Go to Settings > Database" -ForegroundColor Cyan
    Write-Host "4. Copy your database credentials" -ForegroundColor Cyan
    Write-Host "5. Edit the .env file in this directory" -ForegroundColor Cyan
    Write-Host ""
    
    $continue = Read-Host "Have you updated the .env file? (y/n)"
    if ($continue -ne "y") {
        Write-Host "Please update .env file and run this script again" -ForegroundColor Yellow
        exit
    }
}

# Run migrations
Write-Host ""
Write-Host "Creating database migrations..." -ForegroundColor Yellow
python manage.py makemigrations
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Migrations created" -ForegroundColor Green
} else {
    Write-Host "✗ Failed to create migrations" -ForegroundColor Red
    exit
}

Write-Host ""
Write-Host "Running migrations..." -ForegroundColor Yellow
python manage.py migrate
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Database setup complete" -ForegroundColor Green
} else {
    Write-Host "✗ Failed to run migrations. Check your database credentials!" -ForegroundColor Red
    exit
}

# Ask about superuser
Write-Host ""
$createSuperuser = Read-Host "Do you want to create an admin user? (y/n)"
if ($createSuperuser -eq "y") {
    python manage.py createsuperuser
}

# Get local IP
Write-Host ""
Write-Host "Getting your local IP address..." -ForegroundColor Yellow
$ipAddress = (Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias 'Wi-Fi*', 'Ethernet*' | Select-Object -First 1).IPAddress
Write-Host "Your local IP: $ipAddress" -ForegroundColor Cyan

# Success message
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  Backend Setup Complete! ✓" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Start the server:" -ForegroundColor White
Write-Host "   python manage.py runserver 0.0.0.0:8000" -ForegroundColor Yellow
Write-Host ""
Write-Host "2. Update frontend config.js with:" -ForegroundColor White
Write-Host "   http://$ipAddress:8000/api" -ForegroundColor Yellow
Write-Host ""
Write-Host "3. Access admin panel at:" -ForegroundColor White
Write-Host "   http://localhost:8000/admin" -ForegroundColor Yellow
Write-Host ""

# Ask if they want to start server now
$startServer = Read-Host "Start the server now? (y/n)"
if ($startServer -eq "y") {
    Write-Host ""
    Write-Host "Starting Django server..." -ForegroundColor Green
    Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Yellow
    Write-Host ""
    python manage.py runserver 0.0.0.0:8000
}

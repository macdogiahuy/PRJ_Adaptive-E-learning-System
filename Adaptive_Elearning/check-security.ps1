# Security Configuration Checker Script for Windows PowerShell
# Check if all security configurations are properly set up

Write-Host "Security Configuration Check" -ForegroundColor Cyan
Write-Host "============================" -ForegroundColor Cyan

# Check env.properties file
if (Test-Path "src/conf/env.properties") {
    Write-Host "✅ env.properties file exists" -ForegroundColor Green
    
    $envContent = Get-Content "src/conf/env.properties" -Raw
    
    # Check required database variables
    if ($envContent -match "DB_URL=" -and $envContent -match "DB_USER=" -and $envContent -match "DB_PASSWORD=") {
        Write-Host "✅ Database configuration found" -ForegroundColor Green
    } else {
        Write-Host "❌ Missing database configuration in env.properties" -ForegroundColor Red
    }
    
    # Check Google OAuth configuration
    if ($envContent -match "GOOGLE_CLIENT_ID=REDACTED
        Write-Host "✅ Google OAuth configuration found" -ForegroundColor Green
    } else {
        Write-Host "⚠️  Google OAuth configuration not found (skip if not using Google login)" -ForegroundColor Yellow
    }
    
    # Check for placeholder values
    if ($envContent -match "your_username|your_password|your_google_client") {
        Write-Host "❌ Still contains placeholder values in env.properties" -ForegroundColor Red
        Write-Host "   Please update with real credentials" -ForegroundColor Red
    } else {
        Write-Host "✅ No placeholder values found" -ForegroundColor Green
    }
    
} else {
    Write-Host "❌ env.properties file does not exist" -ForegroundColor Red
    Write-Host "   Run: Copy-Item 'src/conf/env.properties.example' 'src/conf/env.properties'" -ForegroundColor Red
}

# Check .gitignore
if (Test-Path ".gitignore") {
    $gitignoreContent = Get-Content ".gitignore" -Raw
    if ($gitignoreContent -match "env.properties") {
        Write-Host "✅ env.properties is gitignored" -ForegroundColor Green
    } else {
        Write-Host "❌ env.properties is not gitignored" -ForegroundColor Red
    }
} else {
    Write-Host "❌ .gitignore file does not exist" -ForegroundColor Red
}

# Check for sensitive files in git
Write-Host ""
Write-Host "Checking for sensitive files in git..." -ForegroundColor Cyan
try {
    $gitFiles = git ls-files 2>$null | Where-Object { $_ -match "\.(properties|env)$" -and $_ -notmatch "\.example$" }
    if ($gitFiles) {
        Write-Host "⚠️  Found properties files in git:" -ForegroundColor Yellow
        $gitFiles | ForEach-Object { Write-Host "   $_" -ForegroundColor Yellow }
        Write-Host "   Check if they contain sensitive information" -ForegroundColor Yellow
    } else {
        Write-Host "✅ No sensitive properties files found in git" -ForegroundColor Green
    }
} catch {
    Write-Host "⚠️  Cannot check git files (git might not be initialized)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Summary:" -ForegroundColor Cyan
Write-Host "- Ensure env.properties is configured with real credentials"
Write-Host "- Never commit env.properties file"
Write-Host "- Only commit env.properties.example (template)"
Write-Host "- Check .gitignore includes sensitive files"

Write-Host ""
Write-Host "To setup Google OAuth:" -ForegroundColor Cyan
Write-Host "1. Go to https://console.cloud.google.com/"
Write-Host "2. Create OAuth 2.0 Client ID"
Write-Host "3. Update GOOGLE_CLIENT_ID and GOOGLE_CLIENT_SECRET in env.properties"
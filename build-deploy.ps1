# Build and Deploy Script for Adaptive E-learning Course Player
# Created: November 3, 2025

Write-Host "🚀 BUILDING ADAPTIVE E-LEARNING PROJECT..." -ForegroundColor Green

# Variables
$PROJECT_PATH = "C:\Users\datdi\Downloads\Adaptive_Elearning\Adaptive_Elearning"
$TOMCAT_PATH = "C:\Program Files\Apache Tomcat 9.0"
$MAVEN_PATH = "C:\Program Files\JetBrains\IntelliJ IDEA 2025.1\plugins\maven\lib\maven3\bin\mvn.cmd"

# Alternative Maven paths to try
$MAVEN_ALTERNATIVES = @(
    "C:\Program Files\Apache Maven\apache-maven-3.9.9\bin\mvn.cmd",
    "C:\Program Files\Maven\apache-maven-3.9.9\bin\mvn.cmd",
    "mvn"
)

Write-Host "📁 Setting project directory..." -ForegroundColor Yellow
Set-Location $PROJECT_PATH

# Find Maven
Write-Host "🔍 Looking for Maven..." -ForegroundColor Yellow
$FOUND_MAVEN = $null

foreach ($maven in @($MAVEN_PATH) + $MAVEN_ALTERNATIVES) {
    try {
        if (Test-Path $maven -ErrorAction SilentlyContinue) {
            $FOUND_MAVEN = $maven
            Write-Host "✅ Found Maven at: $maven" -ForegroundColor Green
            break
        }
    } catch {
        # Try next one
    }
}

if (-not $FOUND_MAVEN) {
    try {
        & mvn --version > $null 2>&1
        if ($LASTEXITCODE -eq 0) {
            $FOUND_MAVEN = "mvn"
            Write-Host "✅ Found Maven in PATH" -ForegroundColor Green
        }
    } catch {
        Write-Host "❌ Maven not found! Please install Maven or add to PATH" -ForegroundColor Red
        exit 1
    }
}

# Clean and compile
Write-Host "🧹 Cleaning project..." -ForegroundColor Yellow
try {
    & $FOUND_MAVEN clean
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Maven clean failed!" -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "❌ Error running Maven clean: $_" -ForegroundColor Red
    exit 1
}

# Package (skip tests for faster build)
Write-Host "📦 Building WAR file..." -ForegroundColor Yellow
try {
    & $FOUND_MAVEN package -DskipTests
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Maven package failed!" -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "❌ Error running Maven package: $_" -ForegroundColor Red
    exit 1
}

# Check if WAR was created
$WAR_FILE = "$PROJECT_PATH\target\Adaptive_Elearning.war"
if (-not (Test-Path $WAR_FILE)) {
    Write-Host "❌ WAR file not found at: $WAR_FILE" -ForegroundColor Red
    exit 1
}

Write-Host "✅ WAR file created successfully!" -ForegroundColor Green

# Deploy to Tomcat
if (Test-Path "$TOMCAT_PATH\webapps") {
    Write-Host "🚀 Deploying to Tomcat..." -ForegroundColor Yellow
    
    # Stop Tomcat if running
    try {
        net stop "Apache Tomcat 9.0" 2>$null
        Write-Host "🛑 Stopped Tomcat service" -ForegroundColor Yellow
    } catch {
        Write-Host "ℹ️ Tomcat service not running or couldn't stop" -ForegroundColor Gray
    }
    
    # Remove old deployment
    $OLD_DEPLOYMENT = "$TOMCAT_PATH\webapps\Adaptive_Elearning"
    if (Test-Path $OLD_DEPLOYMENT) {
        Remove-Item $OLD_DEPLOYMENT -Recurse -Force
        Write-Host "🗑️ Removed old deployment" -ForegroundColor Yellow
    }
    
    if (Test-Path "$TOMCAT_PATH\webapps\Adaptive_Elearning.war") {
        Remove-Item "$TOMCAT_PATH\webapps\Adaptive_Elearning.war" -Force
        Write-Host "🗑️ Removed old WAR file" -ForegroundColor Yellow
    }
    
    # Copy new WAR
    Copy-Item $WAR_FILE "$TOMCAT_PATH\webapps\" -Force
    Write-Host "📋 Copied WAR to Tomcat webapps" -ForegroundColor Green
    
    # Start Tomcat
    try {
        net start "Apache Tomcat 9.0"
        Write-Host "▶️ Started Tomcat service" -ForegroundColor Green
    } catch {
        Write-Host "❌ Failed to start Tomcat service: $_" -ForegroundColor Red
        Write-Host "💡 Try starting Tomcat manually" -ForegroundColor Yellow
    }
    
    # Wait for deployment
    Write-Host "⏳ Waiting for application to deploy..." -ForegroundColor Yellow
    Start-Sleep -Seconds 10
    
    Write-Host "🎉 DEPLOYMENT COMPLETE!" -ForegroundColor Green
    Write-Host ""
    Write-Host "📋 NEXT STEPS:" -ForegroundColor Cyan
    Write-Host "1. Wait 30 seconds for full deployment" -ForegroundColor White
    Write-Host "2. Test upload form: http://localhost:8080/Adaptive_Elearning/instructor/upload-form.jsp" -ForegroundColor White
    Write-Host "3. Test course player with a course ID:" -ForegroundColor White
    Write-Host "   http://localhost:8080/Adaptive_Elearning/course-player?id=YOUR_COURSE_ID" -ForegroundColor White
    Write-Host "4. Check API endpoint: http://localhost:8080/Adaptive_Elearning/api/get-lecture-materials?lectureId=YOUR_LECTURE_ID" -ForegroundColor White
    Write-Host ""
    Write-Host "🔍 CHECK TOMCAT LOGS:" -ForegroundColor Cyan
    Write-Host "   Get-Content '$TOMCAT_PATH\logs\catalina.log' -Tail 50" -ForegroundColor Gray
    
} else {
    Write-Host "❌ Tomcat webapps directory not found at: $TOMCAT_PATH\webapps" -ForegroundColor Red
    Write-Host "💡 WAR file is ready at: $WAR_FILE" -ForegroundColor Yellow
    Write-Host "💡 Deploy manually to your Tomcat server" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "✅ BUILD COMPLETED SUCCESSFULLY!" -ForegroundColor Green
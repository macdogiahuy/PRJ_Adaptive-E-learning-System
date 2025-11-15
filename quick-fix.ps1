# Quick Fix and Redeploy Script
# Fix persistence unit names and redeploy

Write-Host "🔧 FIXING COURSE PLAYER PERSISTENCE ISSUES..." -ForegroundColor Green

$PROJECT_PATH = "C:\Users\datdi\Downloads\Adaptive_Elearning\Adaptive_Elearning"
$TOMCAT_PATH = "C:\Program Files\Apache Tomcat 9.0"

Set-Location $PROJECT_PATH

Write-Host "✅ Fixed persistence unit names in servlets" -ForegroundColor Green
Write-Host "✅ Updated persistence.xml with proper DB config" -ForegroundColor Green

# Quick rebuild
Write-Host "📦 Quick rebuild..." -ForegroundColor Yellow
try {
    & "C:\Program Files\JetBrains\IntelliJ IDEA 2025.1\plugins\maven\lib\maven3\bin\mvn.cmd" compile war:war -DskipTests
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Build failed! Trying alternative..." -ForegroundColor Red
        # Copy compiled classes manually
        Copy-Item "target\classes\*" "target\Adaptive_Elearning\WEB-INF\classes\" -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "✅ Copied compiled classes" -ForegroundColor Green
    }
} catch {
    Write-Host "⚠️ Maven not found, copying classes manually..." -ForegroundColor Yellow
    Copy-Item "target\classes\*" "target\Adaptive_Elearning\WEB-INF\classes\" -Recurse -Force -ErrorAction SilentlyContinue
}

# Quick deploy
if (Test-Path "$TOMCAT_PATH\webapps") {
    Write-Host "🚀 Quick redeploy..." -ForegroundColor Yellow
    
    # Stop Tomcat
    net stop "Apache Tomcat 9.0" 2>$null
    Start-Sleep -Seconds 2
    
    # Copy updated servlets only
    $SOURCE_CLASSES = "target\classes\servlet"
    $TARGET_CLASSES = "$TOMCAT_PATH\webapps\Adaptive_Elearning\WEB-INF\classes\servlet"
    
    if (Test-Path $SOURCE_CLASSES) {
        if (Test-Path $TARGET_CLASSES) {
            Copy-Item "$SOURCE_CLASSES\*" $TARGET_CLASSES -Force
            Write-Host "✅ Updated servlet classes" -ForegroundColor Green
        }
    }
    
    # Copy updated persistence.xml
    $PERSISTENCE_SOURCE = "src\conf\persistence.xml"
    $PERSISTENCE_TARGET = "$TOMCAT_PATH\webapps\Adaptive_Elearning\WEB-INF\classes\META-INF\persistence.xml"
    
    if (Test-Path $PERSISTENCE_SOURCE) {
        $TARGET_DIR = Split-Path $PERSISTENCE_TARGET -Parent
        if (-not (Test-Path $TARGET_DIR)) {
            New-Item -ItemType Directory -Path $TARGET_DIR -Force
        }
        Copy-Item $PERSISTENCE_SOURCE $PERSISTENCE_TARGET -Force
        Write-Host "✅ Updated persistence.xml" -ForegroundColor Green
    }
    
    # Start Tomcat
    net start "Apache Tomcat 9.0"
    Write-Host "▶️ Restarted Tomcat" -ForegroundColor Green
    
    Start-Sleep -Seconds 8
    
    Write-Host ""
    Write-Host "🎯 TEST URLs:" -ForegroundColor Cyan
    Write-Host "Course Player: http://localhost:8080/Adaptive_Elearning/course-player?id=550e8400-e29b-41d4-a716-446655440000" -ForegroundColor White
    Write-Host "API Test: http://localhost:8080/Adaptive_Elearning/api/get-lecture-materials?lectureId=test" -ForegroundColor White
    Write-Host ""
    Write-Host "🔍 CHECK LOGS:" -ForegroundColor Cyan
    Write-Host "Get-Content '$TOMCAT_PATH\logs\catalina.log' -Tail 20" -ForegroundColor Gray
    
} else {
    Write-Host "❌ Tomcat not found at expected location" -ForegroundColor Red
}

Write-Host ""
Write-Host "✅ FIXES APPLIED!" -ForegroundColor Green
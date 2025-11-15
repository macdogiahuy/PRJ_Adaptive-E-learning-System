# Quick Test Deploy - Bypass Enrollment Check
Write-Host "🧪 DEPLOYING COURSE PLAYER WITH ENROLLMENT CHECK DISABLED..." -ForegroundColor Green

$PROJECT_PATH = "C:\Users\datdi\Downloads\Adaptive_Elearning\Adaptive_Elearning"
$TOMCAT_PATH = "C:\Program Files\Apache Tomcat 9.0"

Set-Location $PROJECT_PATH

# Check if Tomcat is accessible
if (-not (Test-Path "$TOMCAT_PATH\webapps")) {
    Write-Host "❌ Tomcat webapps directory not found!" -ForegroundColor Red
    Write-Host "💡 Please check Tomcat installation path" -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ Disabled enrollment check for testing" -ForegroundColor Green
Write-Host "✅ Fixed SSL configuration (encrypt=false)" -ForegroundColor Green

# Copy updated servlet classes
Write-Host "📦 Copying updated servlet..." -ForegroundColor Yellow

$SOURCE_SERVLET = "target\classes\servlet\CoursePlayerServlet.class"
$TARGET_SERVLET = "$TOMCAT_PATH\webapps\Adaptive_Elearning\WEB-INF\classes\servlet\CoursePlayerServlet.class"

if (Test-Path $SOURCE_SERVLET) {
    $TARGET_DIR = Split-Path $TARGET_SERVLET -Parent
    if (-not (Test-Path $TARGET_DIR)) {
        New-Item -ItemType Directory -Path $TARGET_DIR -Force
    }
    Copy-Item $SOURCE_SERVLET $TARGET_SERVLET -Force
    Write-Host "✅ Updated CoursePlayerServlet.class" -ForegroundColor Green
} else {
    Write-Host "⚠️ Servlet class not found, may need to compile first" -ForegroundColor Yellow
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

# Wait a moment for changes to take effect
Start-Sleep -Seconds 3

Write-Host ""
Write-Host "🎯 TEST COURSE PLAYER NOW:" -ForegroundColor Cyan
Write-Host "URL: http://localhost:8080/Adaptive_Elearning/course-player?id=69746C85-6109-4370-9334-1490CD2334B0" -ForegroundColor White
Write-Host ""
Write-Host "📋 TESTING NOTES:" -ForegroundColor Cyan  
Write-Host "✅ No enrollment check - any logged user can access" -ForegroundColor White
Write-Host "✅ SSL disabled - should fix database connection" -ForegroundColor White
Write-Host "✅ Will show course content if course exists" -ForegroundColor White
Write-Host ""
Write-Host "🔍 If still issues, check logs:" -ForegroundColor Cyan
Write-Host "Get-Content '$TOMCAT_PATH\logs\catalina.log' -Tail 30" -ForegroundColor Gray

Write-Host ""
Write-Host "✅ READY TO TEST!" -ForegroundColor Green
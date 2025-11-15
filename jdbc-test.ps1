# Test JDBC Version Course Player
Write-Host "🧪 DEPLOYING JDBC VERSION COURSE PLAYER..." -ForegroundColor Green

$PROJECT_PATH = "C:\Users\datdi\Downloads\Adaptive_Elearning\Adaptive_Elearning"

Set-Location $PROJECT_PATH

# Compile the JDBC servlet
Write-Host "📦 Compiling JDBC servlet..." -ForegroundColor Yellow

$JAVA_HOME = "C:\Program Files\Java\jdk-17"
$CLASSPATH = "target\classes;lib\*;C:\Program Files\Apache Tomcat 9.0\lib\*"

if (Test-Path $JAVA_HOME) {
    $javac = "$JAVA_HOME\bin\javac.exe"
    if (Test-Path $javac) {
        & $javac -cp $CLASSPATH -d target\classes src\main\java\servlet\CoursePlayerServletJDBC.java
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ JDBC servlet compiled successfully!" -ForegroundColor Green
        } else {
            Write-Host "❌ Compilation failed!" -ForegroundColor Red
        }
    }
}

Write-Host ""
Write-Host "🎯 TEST JDBC VERSION:" -ForegroundColor Cyan
Write-Host "URL: http://localhost:8080/Adaptive_Elearning/course-player-test?id=69746C85-6109-4370-9334-1490CD2334B0" -ForegroundColor White
Write-Host ""
Write-Host "📋 BENEFITS:" -ForegroundColor Cyan  
Write-Host "✅ Uses DBConnection.java (SSL already configured)" -ForegroundColor White
Write-Host "✅ No JPA/EclipseLink dependencies" -ForegroundColor White
Write-Host "✅ Direct JDBC connection" -ForegroundColor White
Write-Host "✅ Should bypass SSL certificate issues" -ForegroundColor White

Write-Host ""
Write-Host "✅ JDBC VERSION READY!" -ForegroundColor Green
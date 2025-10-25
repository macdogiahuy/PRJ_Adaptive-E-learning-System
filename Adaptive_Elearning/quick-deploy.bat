@echo off
echo ============================================
echo CART FEATURE - QUICK DEPLOYMENT
echo ============================================
echo.

echo [1/4] Stopping Tomcat...
taskkill /F /FI "WINDOWTITLE eq Tomcat*" 2>nul
timeout /t 3 /nobreak >nul

echo [2/4] Building project...
cd /d "%~dp0"
call mvn clean package -DskipTests -q

if %ERRORLEVEL% NEQ 0 (
    echo BUILD FAILED!
    pause
    exit /b 1
)

echo [3/4] Checking WAR file...
if exist "target\Adaptive_Elearning.war" (
    echo WAR file found: target\Adaptive_Elearning.war
) else (
    echo ERROR: WAR file not found!
    pause
    exit /b 1
)

echo [4/4] Ready to start Tomcat!
echo.
echo ============================================
echo NEXT STEPS:
echo 1. Start Tomcat server manually
echo 2. Clear browser cache (Ctrl+Shift+Del)
echo 3. Go to: http://localhost:8080/Adaptive_Elearning/home
echo 4. Click "Them vao gio hang" button
echo ============================================
echo.
pause

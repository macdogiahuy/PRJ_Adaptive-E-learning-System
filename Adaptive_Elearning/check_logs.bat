@echo off
echo ======================================
echo CHECK TOMCAT LOGS FOR CHECKOUT ERRORS
echo ======================================
echo.

cd /d "%CATALINA_HOME%\logs"

echo Looking for recent checkout logs...
echo.

findstr /i /c:"PROCESSING CHECKOUT" /c:"FALLBACK TO EMAIL" /c:"CHECKOUT SUCCESSFUL" /c:"Enrollment" localhost*.log 2>nul

if errorlevel 1 (
    echo No logs found in default Tomcat location.
    echo.
    echo Please check manually in:
    echo   - CATALINA_HOME/logs/
    echo   - Your project's log files
    echo.
    echo Look for these patterns:
    echo   - "=== PROCESSING CHECKOUT"
    echo   - "FALLBACK TO EMAIL SIMULATION"
    echo   - "Enrolled: [course name]"
    echo   - SQLException or database errors
)

echo.
echo ======================================
echo.
pause

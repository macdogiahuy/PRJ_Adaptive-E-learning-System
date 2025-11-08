@echo off
echo ======================================
echo CHECK SERVER LOGS FOR ERRORS
echo ======================================
echo.
echo Looking for MyCoursesServlet logs...
echo.

cd /d "%USERPROFILE%\Desktop\New folder (3)\PRJ_Adaptive-E-learning-System\Adaptive_Elearning"

echo Checking for Tomcat logs...
if exist "logs\*.log" (
    echo Found logs in project folder
    findstr /i /c:"Processing row" /c:"ERROR processing row" /c:"Successfully added course" logs\*.log 2>nul
) else (
    echo No logs in project folder, checking Catalina...
)

echo.
echo If no output above, please manually check:
echo   1. Your Tomcat logs folder
echo   2. Look for lines containing:
echo      - "Processing row"
echo      - "ERROR processing row"
echo      - "Successfully added course"
echo.
echo Or copy the relevant log section here.
echo.
pause

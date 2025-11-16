@echo off
echo =================================
echo   Tomcat Server - Continuous Mode
echo =================================

echo.
echo Building project...
call mvn clean compile war:war

echo.
echo Starting Tomcat server on port 8080...
echo URL: http://localhost:8080/Adaptive_Elearning
echo.
echo Server is running. To stop, close this window or press Ctrl+C
echo.

mvn cargo:run
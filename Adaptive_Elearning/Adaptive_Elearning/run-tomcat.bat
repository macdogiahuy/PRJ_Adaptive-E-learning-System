@echo off
echo =================================
echo   Maven Tomcat Runner
echo =================================

echo.
echo Starting Tomcat server with Maven...
echo URL: http://localhost:8080/Adaptive_Elearning
echo.
echo Press Ctrl+C to stop the server
echo.

mvn clean tomcat7:run
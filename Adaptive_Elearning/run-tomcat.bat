@echo off
echo =================================
echo   Maven Tomcat 10 Runner
echo =================================

echo.
echo Starting Tomcat 10 server with Maven...
echo URL: http://localhost:8080/Adaptive_Elearning
echo.
echo Press Ctrl+C to stop the server
echo.

echo Building project first...
call mvn clean compile war:war

echo.
echo Starting Tomcat 10 with Cargo plugin...
mvn cargo:run
@echo off
echo =================================
echo   Maven Tomcat 10 Alternative Runner
echo =================================

echo.
echo Building and deploying to Tomcat 10...
echo URL: http://localhost:8080/Adaptive_Elearning
echo.

echo Step 1: Clean and compile...
call mvn clean compile

echo.
echo Step 2: Package WAR file...
call mvn war:war

echo.
echo Step 3: Starting embedded Tomcat 10...
echo Press Ctrl+C to stop the server
echo.

mvn cargo:run

pause
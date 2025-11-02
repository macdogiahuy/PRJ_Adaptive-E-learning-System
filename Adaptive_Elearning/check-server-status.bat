@echo off
echo ================================
echo      SERVER STATUS CHECK
echo ================================

echo Checking if server is running on port 8080...
netstat -an | findstr :8080

echo.
echo Checking Java processes...
tasklist | findstr java

echo.
echo ================================
echo      QUICK COMMANDS
echo ================================
echo 1. To start server: mvn cargo:run
echo 2. To stop server: Ctrl+C in Maven terminal
echo 3. To check logs: check terminal output
echo 4. To rebuild: mvn clean package -DskipTests
echo.
echo Current time: %date% %time%
echo.
pause
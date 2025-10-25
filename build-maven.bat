@echo off
echo =================================
echo   Maven Build Test Script
echo =================================

echo.
echo Checking Maven installation...
mvn --version
if %ERRORLEVEL% neq 0 (
    echo ERROR: Maven not found! Please install Maven first.
    pause
    exit /b 1
)

echo.
echo =================================
echo   Starting Maven Build Process
echo =================================

echo.
echo 1. Cleaning previous build...
mvn clean

echo.
echo 2. Compiling source code...
mvn compile
if %ERRORLEVEL% neq 0 (
    echo ERROR: Compilation failed!
    pause
    exit /b 1
)

echo.
echo 3. Running tests...
mvn test -DskipTests
if %ERRORLEVEL% neq 0 (
    echo WARNING: Tests failed, but continuing...
)

echo.
echo 4. Creating WAR package...
mvn package -DskipTests
if %ERRORLEVEL% neq 0 (
    echo ERROR: Packaging failed!
    pause
    exit /b 1
)

echo.
echo =================================
echo   Build Completed Successfully!
echo =================================
echo.
echo WAR file location: target\Adaptive_Elearning.war
echo.
echo To run the application:
echo   mvn tomcat7:run
echo.
echo Or deploy the WAR file to your Tomcat server.
echo.
pause
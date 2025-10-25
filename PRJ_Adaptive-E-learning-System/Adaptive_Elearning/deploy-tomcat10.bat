@echo off
setlocal enabledelayedexpansion

echo =================================
echo   Tomcat 10 Deployment Script
echo =================================

echo.
echo This script deploys your WAR to a standalone Tomcat 10 server
echo.

REM Default Tomcat paths (adjust if needed)
set TOMCAT_HOME=C:\apache-tomcat-10.1.30
set CATALINA_HOME=%TOMCAT_HOME%
set WEBAPP_DIR=%TOMCAT_HOME%\webapps
set WAR_NAME=Adaptive_Elearning.war

echo Checking Tomcat installation...
if not exist "%TOMCAT_HOME%" (
    echo ERROR: Tomcat not found at %TOMCAT_HOME%
    echo Please install Tomcat 10 or update TOMCAT_HOME path in this script
    echo Download from: https://tomcat.apache.org/download-10.cgi
    pause
    exit /b 1
)

echo.
echo Step 1: Building WAR file...
call mvn clean package -DskipTests

if errorlevel 1 (
    echo ERROR: Maven build failed!
    pause
    exit /b 1
)

echo.
echo Step 2: Stopping Tomcat (if running)...
if exist "%TOMCAT_HOME%\bin\shutdown.bat" (
    call "%TOMCAT_HOME%\bin\shutdown.bat"
    timeout /t 5 /nobreak >nul
)

echo.
echo Step 3: Removing old deployment...
if exist "%WEBAPP_DIR%\Adaptive_Elearning" (
    rmdir /s /q "%WEBAPP_DIR%\Adaptive_Elearning"
)
if exist "%WEBAPP_DIR%\%WAR_NAME%" (
    del "%WEBAPP_DIR%\%WAR_NAME%"
)

echo.
echo Step 4: Deploying new WAR file...
if exist "target\%WAR_NAME%" (
    copy "target\%WAR_NAME%" "%WEBAPP_DIR%\"
    echo WAR file deployed successfully!
) else (
    echo ERROR: WAR file not found in target directory
    pause
    exit /b 1
)

echo.
echo Step 5: Starting Tomcat...
if exist "%TOMCAT_HOME%\bin\startup.bat" (
    call "%TOMCAT_HOME%\bin\startup.bat"
    echo.
    echo Tomcat is starting...
    echo Application will be available at: http://localhost:8080/Adaptive_Elearning
    echo.
    echo Check Tomcat logs at: %TOMCAT_HOME%\logs\catalina.out
) else (
    echo ERROR: Tomcat startup script not found
    pause
    exit /b 1
)

echo.
echo Deployment completed!
echo.
echo To view logs: %TOMCAT_HOME%\logs\
echo To stop Tomcat: %TOMCAT_HOME%\bin\shutdown.bat
echo.
pause
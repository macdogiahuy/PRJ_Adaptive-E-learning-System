@echo off
echo =================================
echo   Simple Tomcat Server Runner
echo =================================

echo.
echo Building project...
call mvn clean compile war:war

echo.
echo Deploying to embedded Tomcat on port 8081...
echo URL: http://localhost:8081/Adaptive_Elearning
echo.

echo Starting server - Press Ctrl+C to stop
java -cp "target/classes;target/Adaptive_Elearning/WEB-INF/lib/*" ^
     -Dserver.port=8081 ^
     -Dspring.web.resources.static-locations=file:src/main/webapp/ ^
     org.springframework.boot.loader.JarLauncher

pause
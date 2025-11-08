@echo off
echo ========================================
echo  DEPLOY FIX TO TOMCAT
echo ========================================
echo.

echo Step 1: Stop Tomcat...
net stop Tomcat10

echo.
echo Step 2: Delete old deployment...
rmdir /s /q "C:\Program Files\Apache Software Foundation\Tomcat 10.1\webapps\Adaptive_Elearning"
del /q "C:\Program Files\Apache Software Foundation\Tomcat 10.1\webapps\Adaptive_Elearning.war"

echo.
echo Step 3: Copy new WAR file...
copy "%~dp0target\Adaptive_Elearning.war" "C:\Program Files\Apache Software Foundation\Tomcat 10.1\webapps\"

echo.
echo Step 4: Start Tomcat...
net start Tomcat10

echo.
echo ========================================
echo  DEPLOYMENT COMPLETE!
echo ========================================
echo.
echo Server is starting... wait 30 seconds
echo Then open: http://localhost:8080/Adaptive_Elearning
echo.
echo TEST:
echo 1. Login as Snow1234
echo 2. Try adding course "123" to cart
echo 3. Should show: "Bạn đã sở hữu khóa học này rồi!"
echo.
pause

@echo off
echo ========================================
echo  CHECK TOMCAT LOGS FOR CHECKOUT
echo ========================================
echo.

cd "C:\Program Files\Apache Software Foundation\Tomcat 10.1\logs"

echo Looking for checkout logs...
echo.

echo === RECENT CHECKOUT LOGS ===
findstr /I /C:"PROCESSING CHECKOUT" /C:"Number of courses:" /C:"Course 1:" /C:"Course 2:" catalina*.log

echo.
echo === STORED PROCEDURE RESULTS ===
findstr /I /C:"Bill ID:" /C:"Checkout ID:" /C:"Result:" /C:"SUCCESS" /C:"FAILED" catalina*.log

echo.
echo === ENROLLMENT CREATION LOGS ===
findstr /I /C:"Creating enrollment" /C:"Enrollment created" /C:"Skipping duplicate" catalina*.log

echo.
echo Done!
pause

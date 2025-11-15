@echo off
echo ================================
echo    INSTRUCTOR ACCESS DEBUG
echo ================================

echo.
echo 1. Server Status:
netstat -an | findstr :8080

echo.
echo 2. Test URLs:
echo    - Home: http://localhost:8080/Adaptive_Elearning/home
echo    - Debug: http://localhost:8080/Adaptive_Elearning/auth-debug.jsp
echo    - Instructor Dashboard: http://localhost:8080/Adaptive_Elearning/instructor-dashboard

echo.
echo 3. Quick Tests:
echo    - Make sure you're logged in as Admin or Instructor
echo    - Check browser console for any JavaScript errors
echo    - Check server logs in Maven terminal for AuthFilter output

echo.
echo 4. If still getting Access Denied:
echo    - Check your user role in auth-debug.jsp
echo    - Verify AuthFilter logs in server terminal
echo    - Try logging out and logging back in

echo.
echo Press any key to open debug page...
pause
start http://localhost:8080/Adaptive_Elearning/auth-debug.jsp
@echo off
REM Script to integrate performance CSS and JS into all admin pages
REM Author: AI Assistant
REM Date: Nov 1, 2025

setlocal enabledelayedexpansion

set "ADMIN_DIR=c:\Users\LP\Desktop\code 50%%\PRJ_Adaptive-E-learning-System\Adaptive_Elearning\src\main\webapp\WEB-INF\views\admin"

set FILES=admin_accountmanagement.jsp admin_coursemanagement.jsp admin_createadmin.jsp admin_edit_user_role.jsp admin_notification.jsp admin_reportedcourse.jsp admin_reportedgroup.jsp

echo ============================================
echo  Integrating Performance Optimization
echo  into Admin Pages
echo ============================================
echo.

for %%F in (%FILES%) do (
    set "FILE=%ADMIN_DIR%\%%F"
    echo Processing: %%F
    
    REM Check if file exists
    if exist "!FILE!" (
        echo   - Found: !FILE!
        
        REM Create backup
        copy /Y "!FILE!" "!FILE!.backup" >nul 2>&1
        echo   - Backup created: %%F.backup
        
        REM Add CSS link after first <link> tag
        powershell -Command "(Get-Content '!FILE!') -replace '(<link[^>]+>)(?!.*admin-performance)', '$1`n    <link rel=\"stylesheet\" href=\"${pageContext.request.contextPath}/assets/css/admin-performance.css\">' | Set-Content '!FILE!.temp'"
        
        REM Add JS script before </body>
        powershell -Command "(Get-Content '!FILE!.temp') -replace '</body>', '    <!-- Admin Performance Optimizer -->`n    <script src=\"${pageContext.request.contextPath}/assets/js/admin-performance.js\"></script>`n</body>' | Set-Content '!FILE!'"
        
        del "!FILE!.temp" >nul 2>&1
        echo   - Performance optimization added
        echo.
    ) else (
        echo   - NOT FOUND: !FILE!
        echo.
    )
)

echo ============================================
echo  Integration Complete!
echo ============================================
echo.
echo Files processed:
for %%F in (%FILES%) do echo   - %%F
echo.
echo Note: Original files backed up with .backup extension
echo.
pause

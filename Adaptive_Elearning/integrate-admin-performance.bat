@echo off
setlocal enabledelayedexpansion

echo ============================================
echo  Integrating Admin Performance Optimization
echo ============================================
echo.

set "ADMIN_VIEWS=c:\Users\LP\Desktop\code 50%%\PRJ_Adaptive-E-learning-System\Adaptive_Elearning\src\main\webapp\WEB-INF\views\admin"

REM Files to process (excluding dashboard.jsp and accountmanagement.jsp - already done)
set FILES=adcoursemanagement.jsp createadmin.jsp edit_user_role.jsp notification.jsp reportedcourse.jsp reportedgroup.jsp

for %%F in (%FILES%) do (
    set "FILE=%ADMIN_VIEWS%\%%F"
    echo Processing: %%F
    
    if exist "!FILE!" (
        REM Create backup
        copy /Y "!FILE!" "!FILE!.backup" >nul 2>&1
        echo   [OK] Backup created
        
        REM Add CSS after last existing <link> tag before <script>
        powershell -Command "$content = Get-Content '!FILE!' -Raw; $pattern = '(<link[^>]*>[^\n]*\n)(?=\s*<script)'; $replacement = '$1    <link rel=\"stylesheet\" href=\"${pageContext.request.contextPath}/assets/css/admin-performance.css\">`n'; $newContent = $content -replace $pattern, $replacement; Set-Content '!FILE!' -Value $newContent -NoNewline"
        
        REM Add JS before </body>
        powershell -Command "$content = Get-Content '!FILE!' -Raw; $pattern = '(\s*</body>)'; $replacement = '`n    <!-- Admin Performance Optimizer -->`n    <script src=\"${pageContext.request.contextPath}/assets/js/admin-performance.js\"></script>`n</body>'; $newContent = $content -replace $pattern, $replacement; Set-Content '!FILE!' -Value $newContent -NoNewline"
        
        echo   [OK] Performance files integrated
    ) else (
        echo   [SKIP] File not found
    )
    echo.
)

echo ============================================
echo  Completed!
echo ============================================
echo.
echo Files processed:
echo   [x] dashboard.jsp (already done)
echo   [x] accountmanagement.jsp (already done)
for %%F in (%FILES%) do echo   [x] %%F
echo.
pause

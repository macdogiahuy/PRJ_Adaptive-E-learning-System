@echo off
cls
color 0A
echo.
echo     ╔══════════════════════════════════════════════════╗
echo     ║   FIX: "Only 1 Course Shows" Issue              ║
echo     ║   Comprehensive Solution Applied                ║
echo     ╚══════════════════════════════════════════════════╝
echo.
color 07
echo.
echo ===============================================
echo  WHAT'S BEEN FIXED
echo ===============================================
echo.
echo ✓ NULL Safety
echo   - All fields have default values
echo   - Try-catch for conversions
echo   - No more NULL exceptions
echo.
echo ✓ Enhanced Logging
echo   - Logs each course as processed
echo   - Shows exact error if row fails
echo   - Prints full row data for debugging
echo.
echo ✓ Duplicate Prevention
echo   - Can't add owned courses to cart
echo   - Clear error message shown
echo.
echo ===============================================
echo  HOW TO PROCEED
echo ===============================================
echo.
echo OPTION 1: Quick Fix (Recommended)
echo   1. run_master_diagnostic.bat
echo      → Identifies the exact issue
echo.
echo   2. rebuild-null-safe.bat
echo      → Applies all fixes
echo.
echo   3. Restart server and test
echo      → Check if both courses show
echo.
echo OPTION 2: I Want to Understand First
echo   1. run_test_mycourses_query.bat
echo      → See what's in database
echo.
echo   2. Check answer:
echo      - If query returns 2 courses → Java code issue
echo      - If query returns 1 course → Database issue
echo.
echo   3. Then apply appropriate fix
echo.
echo ===============================================
echo  EXPECTED OUTCOME
echo ===============================================
echo.
echo After fixes:
echo   ✓ My Courses shows ALL purchased courses
echo   ✓ Java Course visible (from 2023)
echo   ✓ Growth Mindset visible (from 2025)
echo   ✓ Any other enrollments visible
echo   ✓ No courses missing
echo.
echo ===============================================
echo  NEED HELP?
echo ===============================================
echo.
echo Read: STEP_BY_STEP_FIX.md
echo   - Detailed troubleshooting guide
echo   - All scenarios covered
echo   - Step-by-step instructions
echo.
echo Run: run_master_diagnostic.bat
echo   - Automated diagnosis
echo   - Tells you exactly what's wrong
echo   - Guides next steps
echo.
echo ===============================================
echo.
echo Press any key to start quick fix...
pause >nul

echo.
echo Starting diagnostics...
echo.
call run_master_diagnostic.bat

echo.
echo ===============================================
echo.
echo After reviewing diagnostic results above,
echo do you want to rebuild with fixes now?
echo.
choice /C YN /M "Rebuild"

if errorlevel 2 (
    echo.
    echo Skipping rebuild. You can run it later with:
    echo   rebuild-null-safe.bat
    echo.
    pause
    exit /b 0
)

echo.
echo Rebuilding with fixes...
echo.
call rebuild-null-safe.bat

echo.
echo ===============================================
echo  DONE!
echo ===============================================
echo.
echo Next: Restart Tomcat and test My Courses page
echo.
pause

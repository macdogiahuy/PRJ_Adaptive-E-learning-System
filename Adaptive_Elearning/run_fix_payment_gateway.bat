@echo off
echo ===================================
echo Fix Payment Gateway in Database
echo ===================================
echo.

REM Change these variables to match your SQL Server
set SERVER=localhost
set DATABASE=Adaptive_Elearning
set USERNAME=sa
set PASSWORD=your_password

echo Running fix_payment_gateway.sql...
sqlcmd -S %SERVER% -d %DATABASE% -U %USERNAME% -P %PASSWORD% -i "fix_payment_gateway.sql"

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ===================================
    echo SUCCESS! Stored procedure updated
    echo ===================================
    echo.
    echo Payment methods now supported:
    echo   - COD
    echo   - VNPay Online
    echo   - VietQR Banking
    echo.
) else (
    echo.
    echo ===================================
    echo ERROR! Failed to update procedure
    echo ===================================
    echo.
)

pause

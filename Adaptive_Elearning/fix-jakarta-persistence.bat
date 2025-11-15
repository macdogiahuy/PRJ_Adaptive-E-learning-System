@echo off
echo ==========================================
echo   Fixing jakarta.persistence to jakarta.persistence
echo ==========================================

cd /d "d:\ê nha\PRJ_Adaptive-E-learning-System\Adaptive_Elearning\src\main\java\model"

echo.
echo Replacing jakarta.persistence with jakarta.persistence in all model files...

for %%f in (*.java) do (
    echo Processing: %%f
    powershell -Command "(Get-Content '%%f') -replace 'jakarta\.persistence', 'jakarta.persistence' | Set-Content '%%f'"
)

echo.
echo ==========================================
echo   Conversion completed!
echo ==========================================
echo.
echo All model files have been updated to use Jakarta Persistence.
echo You can now run: mvn clean compile
echo.
pause
@echo off
echo ===============================================
echo   FORCE CLEAN AND REBUILD PROJECT
echo ===============================================
echo.
echo Bước 1: Xóa target folder...
if exist target (
    rmdir /s /q target
    echo Target folder deleted!
) else (
    echo Target folder not found.
)

echo.
echo Bước 2: Xóa Maven cache cho project...
if exist "%USERPROFILE%\.m2\repository\com\coursehub" (
    rmdir /s /q "%USERPROFILE%\.m2\repository\com\coursehub"
    echo Maven cache deleted!
)

echo.
echo Bước 3: Clean compile...
call mvn clean

echo.
echo Bước 4: Compile lại...
call mvn compile

echo.
echo Bước 5: Package WAR file...
call mvn war:war

echo.
echo ===============================================
echo   BUILD COMPLETED!
echo ===============================================
echo.
echo WAR file location:
dir target\*.war
echo.
echo Bây giờ hãy restart server bằng lệnh:
echo   mvn cargo:run
echo.
pause

@echo off
setlocal enabledelayedexpansion

:: Duke Desktop Launcher - Release Packaging Script
:: Creates distribution package for GitHub releases

REM Get script directory
set "SCRIPT_DIR=%~dp0"
cd /d "%SCRIPT_DIR%"

REM Version info
set "VERSION=1.0.0"
set "DIST_DIR=%SCRIPT_DIR%dist"
set "PACKAGE_NAME=duke-launcher-v%VERSION%"
set "PACKAGE_DIR=%DIST_DIR%\%PACKAGE_NAME%"

echo.
echo ============================================================
echo        DUKE DESKTOP LAUNCHER - RELEASE PACKAGER
echo ============================================================
echo.
echo Version: %VERSION%
echo Output:  %PACKAGE_DIR%
echo.

REM Clean previous dist
if exist "%DIST_DIR%" (
    echo Cleaning previous build...
    rd /s /q "%DIST_DIR%" 2>nul
)

REM Create package directory structure
echo Creating package structure...
mkdir "%PACKAGE_DIR%" 2>nul
mkdir "%PACKAGE_DIR%\modules" 2>nul
mkdir "%PACKAGE_DIR%\config" 2>nul
mkdir "%PACKAGE_DIR%\assets" 2>nul
mkdir "%PACKAGE_DIR%\assets\matrix-frames" 2>nul
mkdir "%PACKAGE_DIR%\logs" 2>nul

echo.
echo Copying files...
echo.

REM Copy main launcher
echo [1/7] Main launcher...
copy /y "duke.cmd" "%PACKAGE_DIR%\" >nul
if errorlevel 1 (
    echo ERROR: Failed to copy duke.cmd
    pause
    exit /b 1
)
echo   [OK] duke.cmd

REM Copy all modules
echo [2/7] Modules...
set /a "MODULE_COUNT=0"
for %%f in (modules\*.cmd) do (
    copy /y "%%f" "%PACKAGE_DIR%\modules\" >nul
    set /a "MODULE_COUNT+=1"
    echo   [OK] %%~nxf
)
echo   Total: !MODULE_COUNT! modules

REM Copy config templates (not user data)
echo [3/7] Config templates...
if exist "config\TEMPLATE-browser-links.txt" (
    copy /y "config\TEMPLATE-browser-links.txt" "%PACKAGE_DIR%\config\" >nul
    echo   [OK] TEMPLATE-browser-links.txt
)
REM Create empty placeholder for logs (Git doesn't track empty folders)
echo. > "%PACKAGE_DIR%\logs\.gitkeep"
echo   [OK] logs folder prepared

REM Copy assets
echo [4/7] Assets...
if exist "assets\banner.txt" (
    copy /y "assets\banner.txt" "%PACKAGE_DIR%\assets\" >nul
    echo   [OK] banner.txt
)
REM Copy matrix frames if they exist
set /a "FRAME_COUNT=0"
for %%f in (assets\matrix-frames\*.txt) do (
    copy /y "%%f" "%PACKAGE_DIR%\assets\matrix-frames\" >nul
    set /a "FRAME_COUNT+=1"
)
if !FRAME_COUNT! gtr 0 (
    echo   [OK] !FRAME_COUNT! matrix frames
) else (
    echo   [INFO] No matrix frames yet
)

REM Copy documentation
echo [5/7] Documentation...
copy /y "README.md" "%PACKAGE_DIR%\" >nul
echo   [OK] README.md
copy /y "LICENSE" "%PACKAGE_DIR%\" >nul
echo   [OK] LICENSE

REM Copy test script (optional)
echo [6/7] Test utilities...
if exist "test.cmd" (
    copy /y "test.cmd" "%PACKAGE_DIR%\" >nul
    echo   [OK] test.cmd
)

REM Create ZIP archive (using PowerShell)
echo [7/7] Creating ZIP archive...
set "ZIP_FILE=%DIST_DIR%\%PACKAGE_NAME%.zip"

powershell -NoProfile -ExecutionPolicy Bypass -Command "Compress-Archive -Path '%PACKAGE_DIR%' -DestinationPath '%ZIP_FILE%' -Force"

if errorlevel 1 (
    echo ERROR: Failed to create ZIP archive
    pause
    exit /b 1
)

echo   [OK] %PACKAGE_NAME%.zip created

echo.
echo ============================================================
echo                    PACKAGE COMPLETE!
echo ============================================================
echo.
echo Distribution files created:
echo   Folder: %PACKAGE_DIR%
echo   ZIP:    %ZIP_FILE%
echo.

REM Calculate sizes
for %%A in ("%ZIP_FILE%") do set "ZIP_SIZE=%%~zA"
set /a "ZIP_SIZE_KB=ZIP_SIZE/1024"

echo Package size: !ZIP_SIZE_KB! KB
echo.
echo Ready for GitHub release!
echo.

REM Ask to open dist folder
set /p "OPEN_FOLDER=Open dist folder? (Y/N): "
if /i "%OPEN_FOLDER%"=="Y" (
    start "" explorer "%DIST_DIR%"
)

echo.
pause
exit /b 0

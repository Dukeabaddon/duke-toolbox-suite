@echo off
setlocal enabledelayedexpansion

:: Duke Desktop Launcher - System Health Check
:: Runs system integrity checks and diagnostics

call "%~dp0colors.cmd"

:HealthMenu
cls
echo.
echo %HEADER%%SEPARATOR%%RESET%
echo %HEADER%         SYSTEM HEALTH CHECK%RESET%
echo %HEADER%%SEPARATOR%%RESET%
echo.

echo %WARNING%Note: Some operations require Administrator privileges.%RESET%
echo.

echo %BRACKET%[%RESET%%TEXT%1%RESET%%BRACKET%]%RESET% %TEXT%System File Checker (SFC)%RESET%
echo %BRACKET%[%RESET%%TEXT%2%RESET%%BRACKET%]%RESET% %TEXT%Check Disk (CHKDSK)%RESET%
echo %BRACKET%[%RESET%%TEXT%3%RESET%%BRACKET%]%RESET% %TEXT%DISM Health Scan%RESET%
echo %BRACKET%[%RESET%%TEXT%4%RESET%%BRACKET%]%RESET% %TEXT%Full System Scan (All Checks)%RESET%
echo %BRACKET%[%RESET%%TEXT%5%RESET%%BRACKET%]%RESET% %TEXT%View Previous Scan Logs%RESET%
echo.
echo %BRACKET%[%RESET%%TEXT%0%RESET%%BRACKET%]%RESET% %TEXT%Back to Main Menu%RESET%
echo.
echo %HEADER%%SEPARATOR%%RESET%
echo.

set /p "CHOICE=%BRACKET%[%RESET%%TEXT%?%RESET%%BRACKET%]%RESET% %TEXT%Select option: %RESET%"

if "%CHOICE%"=="0" exit /b 0
if "%CHOICE%"=="1" goto RunSFC
if "%CHOICE%"=="2" goto RunCHKDSK
if "%CHOICE%"=="3" goto RunDISM
if "%CHOICE%"=="4" goto RunFull
if "%CHOICE%"=="5" goto ViewLogs

echo %ERROR%Invalid selection!%RESET%
timeout /t 2 >nul
goto HealthMenu

:RunSFC
cls
echo.
echo %HEADER%%SEPARATOR%%RESET%
echo %HEADER%      SYSTEM FILE CHECKER (SFC)%RESET%
echo %HEADER%%SEPARATOR%%RESET%
echo.

:: Check for admin rights
net session >nul 2>&1
if errorlevel 1 (
    echo %ERROR%Administrator privileges required!%RESET%
    echo %TEXT%Please run this launcher as Administrator.%RESET%
    echo.
    pause
    goto HealthMenu
)

echo %TEXT%Running System File Checker...%RESET%
echo %WARNING%This may take several minutes. Please wait...%RESET%
echo.

set "LOGFILE=%~dp0..\logs\sfc-%DATE:/=-%_%TIME::=-%"
set "LOGFILE=%LOGFILE: =_%"
set "LOGFILE=%LOGFILE:.txt=%.txt"

sfc /scannow | tee "%LOGFILE%"

echo.
echo %SUCCESS%Scan complete!%RESET%
echo %TEXT%Log saved to:%RESET% %BRACKET%%LOGFILE%%RESET%
echo.
pause
goto HealthMenu

:RunCHKDSK
cls
echo.
echo %HEADER%%SEPARATOR%%RESET%
echo %HEADER%            CHECK DISK (CHKDSK)%RESET%
echo %HEADER%%SEPARATOR%%RESET%
echo.

:: Check for admin rights
net session >nul 2>&1
if errorlevel 1 (
    echo %ERROR%Administrator privileges required!%RESET%
    echo %TEXT%Please run this launcher as Administrator.%RESET%
    echo.
    pause
    goto HealthMenu
)

echo %WARNING%CHKDSK Options:%RESET%
echo.
echo %BRACKET%[%RESET%%TEXT%1%RESET%%BRACKET%]%RESET% %TEXT%Quick scan (read-only check)%RESET%
echo %BRACKET%[%RESET%%TEXT%2%RESET%%BRACKET%]%RESET% %TEXT%Schedule full scan on next reboot%RESET%
echo %BRACKET%[%RESET%%TEXT%0%RESET%%BRACKET%]%RESET% %TEXT%Cancel%RESET%
echo.

set /p "CHKDSK_CHOICE=%BRACKET%[%RESET%%TEXT%?%RESET%%BRACKET%]%RESET% %TEXT%Select: %RESET%"

if "%CHKDSK_CHOICE%"=="0" goto HealthMenu
if "%CHKDSK_CHOICE%"=="1" (
    echo.
    echo %TEXT%Running quick disk check on C:...%RESET%
    chkdsk C:
    echo.
    pause
    goto HealthMenu
)
if "%CHKDSK_CHOICE%"=="2" (
    echo.
    echo %TEXT%Scheduling full disk check on next reboot...%RESET%
    echo %WARNING%The system will need to restart for this scan.%RESET%
    chkdsk C: /F /R
    echo.
    pause
    goto HealthMenu
)

goto HealthMenu

:RunDISM
cls
echo.
echo %HEADER%%SEPARATOR%%RESET%
echo %HEADER%              DISM HEALTH SCAN%RESET%
echo %HEADER%%SEPARATOR%%RESET%
echo.

:: Check for admin rights
net session >nul 2>&1
if errorlevel 1 (
    echo %ERROR%Administrator privileges required!%RESET%
    echo %TEXT%Please run this launcher as Administrator.%RESET%
    echo.
    pause
    goto HealthMenu
)

echo %TEXT%Running DISM health checks...%RESET%
echo.

set "LOGFILE=%~dp0..\logs\dism-%DATE:/=-%_%TIME::=-%"
set "LOGFILE=%LOGFILE: =_%"
set "LOGFILE=%LOGFILE:.txt=%.txt"

echo %BRACKET%[%RESET%%TEXT%1/3%RESET%%BRACKET%]%RESET% %TEXT%Checking component store health...%RESET%
DISM /Online /Cleanup-Image /CheckHealth

echo.
echo %BRACKET%[%RESET%%TEXT%2/3%RESET%%BRACKET%]%RESET% %TEXT%Scanning for corruption...%RESET%
DISM /Online /Cleanup-Image /ScanHealth

echo.
echo %BRACKET%[%RESET%%TEXT%3/3%RESET%%BRACKET%]%RESET% %TEXT%Restoring system health (if needed)...%RESET%
DISM /Online /Cleanup-Image /RestoreHealth

echo.
echo %SUCCESS%DISM scan complete!%RESET%
echo.
pause
goto HealthMenu

:RunFull
cls
echo.
echo %HEADER%%SEPARATOR%%RESET%
echo %HEADER%         FULL SYSTEM HEALTH SCAN%RESET%
echo %HEADER%%SEPARATOR%%RESET%
echo.

:: Check for admin rights
net session >nul 2>&1
if errorlevel 1 (
    echo %ERROR%Administrator privileges required!%RESET%
    echo %TEXT%Please run this launcher as Administrator.%RESET%
    echo.
    pause
    goto HealthMenu
)

echo %WARNING%This will run:%RESET%
echo   %BULLET% DISM Health Check
echo   %BULLET% System File Checker (SFC)
echo   %BULLET% Quick Disk Check (CHKDSK)
echo.
echo %TEXT%This process may take 15-30 minutes.%RESET%
echo.

set /p "CONFIRM=%BRACKET%[%RESET%%TEXT%?%RESET%%BRACKET%]%RESET% %TEXT%Continue? (Y/N): %RESET%"
if /i not "%CONFIRM%"=="Y" goto HealthMenu

echo.
echo %HEADER%Starting full system scan...%RESET%
echo.

REM Step 1: DISM
echo %BRACKET%[%RESET%%TEXT%Step 1/3%RESET%%BRACKET%]%RESET% %TEXT%Running DISM health checks...%RESET%
DISM /Online /Cleanup-Image /CheckHealth
DISM /Online /Cleanup-Image /ScanHealth
DISM /Online /Cleanup-Image /RestoreHealth
echo %SUCCESS%DISM complete.%RESET%
echo.

REM Step 2: SFC
echo %BRACKET%[%RESET%%TEXT%Step 2/3%RESET%%BRACKET%]%RESET% %TEXT%Running System File Checker...%RESET%
sfc /scannow
echo %SUCCESS%SFC complete.%RESET%
echo.

REM Step 3: CHKDSK
echo %BRACKET%[%RESET%%TEXT%Step 3/3%RESET%%BRACKET%]%RESET% %TEXT%Running quick disk check...%RESET%
chkdsk C:
echo %SUCCESS%Disk check complete.%RESET%
echo.

echo %HEADER%%SEPARATOR%%RESET%
echo %SUCCESS%Full system health scan completed!%RESET%
echo %TEXT%Review the output above for any detected issues.%RESET%
echo %HEADER%%SEPARATOR%%RESET%
echo.
pause
goto HealthMenu

:ViewLogs
cls
echo.
echo %HEADER%%SEPARATOR%%RESET%
echo %HEADER%           SYSTEM HEALTH LOGS%RESET%
echo %HEADER%%SEPARATOR%%RESET%
echo.

set "LOGS_DIR=%~dp0..\logs"

if not exist "%LOGS_DIR%\*.*" (
    echo %ERROR%No logs found.%RESET%
    echo %TEXT%Run a health check first to generate logs.%RESET%
    echo.
    pause
    goto HealthMenu
)

echo %TEXT%Available logs:%RESET%
echo.

set /a "LOG_COUNT=0"
for %%f in ("%LOGS_DIR%\*.txt") do (
    set /a "LOG_COUNT+=1"
    echo   %BULLET% %%~nxf
)

if !LOG_COUNT! equ 0 (
    echo %ERROR%No log files found.%RESET%
) else (
    echo.
    echo %TEXT%Opening logs folder...%RESET%
    start "" explorer "%LOGS_DIR%"
)

echo.
pause
goto HealthMenu

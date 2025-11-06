@echo off
setlocal enabledelayedexpansion

:: Duke Desktop Launcher - Power Report Module
:: Battery and energy consumption analysis

call "%~dp0colors.cmd"

:PowerMenu
cls
echo.
echo %HEADER%%SEPARATOR%%RESET%
echo %HEADER%            POWER REPORT%RESET%
echo %HEADER%%SEPARATOR%%RESET%
echo.

REM Detect if laptop or desktop
systeminfo | findstr /C:"System Type" | findstr /C:"Laptop" >nul 2>&1
if errorlevel 1 (
    set "DEVICE_TYPE=Desktop"
    set "IS_LAPTOP=0"
) else (
    set "DEVICE_TYPE=Laptop"
    set "IS_LAPTOP=1"
)

echo %TEXT%Device Type:%RESET% %BRACKET%!DEVICE_TYPE!%RESET%
echo.

if !IS_LAPTOP! equ 1 (
    echo %BRACKET%[%RESET%%TEXT%1%RESET%%BRACKET%]%RESET% %TEXT%Battery Report%RESET%
    echo %BRACKET%[%RESET%%TEXT%2%RESET%%BRACKET%]%RESET% %TEXT%Battery Health Status%RESET%
)
echo %BRACKET%[%RESET%%TEXT%3%RESET%%BRACKET%]%RESET% %TEXT%Energy Report (Requires Admin)%RESET%
echo %BRACKET%[%RESET%%TEXT%4%RESET%%BRACKET%]%RESET% %TEXT%Power Plan Settings%RESET%
echo %BRACKET%[%RESET%%TEXT%5%RESET%%BRACKET%]%RESET% %TEXT%Sleep Study (Requires Admin)%RESET%
echo %BRACKET%[%RESET%%TEXT%6%RESET%%BRACKET%]%RESET% %TEXT%View Power Scheme%RESET%
echo.
echo %BRACKET%[%RESET%%TEXT%0%RESET%%BRACKET%]%RESET% %TEXT%Back to Main Menu%RESET%
echo.
echo %HEADER%%SEPARATOR%%RESET%
echo.

set /p "CHOICE=%BRACKET%[%RESET%%TEXT%?%RESET%%BRACKET%]%RESET% %TEXT%Select option: %RESET%"

if "%CHOICE%"=="0" exit /b 0
if "%CHOICE%"=="1" if !IS_LAPTOP! equ 1 goto BatteryReport
if "%CHOICE%"=="2" if !IS_LAPTOP! equ 1 goto BatteryHealth
if "%CHOICE%"=="3" goto EnergyReport
if "%CHOICE%"=="4" goto PowerPlan
if "%CHOICE%"=="5" goto SleepStudy
if "%CHOICE%"=="6" goto PowerScheme

echo %ERROR%Invalid selection!%RESET%
timeout /t 2 >nul
goto PowerMenu

:BatteryReport
cls
echo.
echo %HEADER%%SEPARATOR%%RESET%
echo %HEADER%            BATTERY REPORT%RESET%
echo %HEADER%%SEPARATOR%%RESET%
echo.

set "REPORT_FILE=%~dp0..\logs\battery-report-%DATE:/=-%_%TIME::=-%.html"
set "REPORT_FILE=!REPORT_FILE: =_!"

echo %TEXT%Generating battery report...%RESET%
echo.

powercfg /batteryreport /output "!REPORT_FILE!" >nul 2>&1

if errorlevel 1 (
    echo %ERROR%Failed to generate report!%RESET%
    echo %TEXT%This feature requires a battery-powered device.%RESET%
) else (
    echo %SUCCESS%Battery report generated!%RESET%
    echo %TEXT%Location:%RESET% %BRACKET%!REPORT_FILE!%RESET%
    echo.
    echo %TEXT%Opening report in browser...%RESET%
    start "" "!REPORT_FILE!"
)

echo.
echo %BRACKET%[%RESET%%TEXT%0%RESET%%BRACKET%]%RESET% %TEXT%Back to Power Menu%RESET%
echo.
choice /c 0 /n /m ""
goto PowerMenu

:BatteryHealth
cls
echo.
echo %HEADER%%SEPARATOR%%RESET%
echo %HEADER%         BATTERY HEALTH STATUS%RESET%
echo %HEADER%%SEPARATOR%%RESET%
echo.

echo %TEXT%Checking battery health...%RESET%
echo.

REM Get battery info using PowerShell
powershell -NoProfile -Command "$battery = Get-WmiObject -Class Win32_Battery; if ($battery) { Write-Host 'Battery Name: ' $battery.Name; Write-Host 'Design Capacity: ' $battery.DesignCapacity 'mWh'; Write-Host 'Full Charge Capacity: ' $battery.FullChargeCapacity 'mWh'; $health = [math]::Round(($battery.FullChargeCapacity / $battery.DesignCapacity) * 100, 2); Write-Host 'Battery Health: ' $health '%%'; Write-Host 'Status: ' $battery.Status; Write-Host 'Chemistry: ' $battery.Chemistry } else { Write-Host 'No battery detected or information unavailable.' }"

echo.
echo %HEADER%%SEPARATOR%%RESET%
echo.
echo %BRACKET%[%RESET%%TEXT%0%RESET%%BRACKET%]%RESET% %TEXT%Back to Power Menu%RESET%
echo.
choice /c 0 /n /m ""
goto PowerMenu

:EnergyReport
cls
echo.
echo %HEADER%%SEPARATOR%%RESET%
echo %HEADER%            ENERGY REPORT%RESET%
echo %HEADER%%SEPARATOR%%RESET%
echo.

REM Check for admin rights
net session >nul 2>&1
if errorlevel 1 (
    echo %ERROR%Administrator privileges required!%RESET%
    echo %TEXT%Please run this launcher as Administrator.%RESET%
    echo.
    pause
    goto PowerMenu
)

set "REPORT_FILE=%~dp0..\logs\energy-report-%DATE:/=-%_%TIME::=-%.html"
set "REPORT_FILE=!REPORT_FILE: =_!"

echo %WARNING%This analysis takes approximately 60 seconds...%RESET%
echo %TEXT%The system will be monitored for energy efficiency.%RESET%
echo.

set /p "CONFIRM=%BRACKET%[%RESET%%TEXT%?%RESET%%BRACKET%]%RESET% %TEXT%Continue? (Y/N): %RESET%"

if /i not "%CONFIRM%"=="Y" goto PowerMenu

echo.
echo %TEXT%Generating energy report...%RESET%
echo %TEXT%Please wait (this takes about 60 seconds)...%RESET%
echo.

powercfg /energy /output "!REPORT_FILE!" /duration 60

if errorlevel 1 (
    echo %ERROR%Failed to generate report!%RESET%
) else (
    echo.
    echo %SUCCESS%Energy report generated!%RESET%
    echo %TEXT%Location:%RESET% %BRACKET%!REPORT_FILE!%RESET%
    echo.
    echo %TEXT%Opening report in browser...%RESET%
    start "" "!REPORT_FILE!"
)

echo.
echo %BRACKET%[%RESET%%TEXT%0%RESET%%BRACKET%]%RESET% %TEXT%Back to Power Menu%RESET%
echo.
choice /c 0 /n /m ""
goto PowerMenu

:PowerPlan
cls
echo.
echo %HEADER%%SEPARATOR%%RESET%
echo %HEADER%          POWER PLAN SETTINGS%RESET%
echo %HEADER%%SEPARATOR%%RESET%
echo.

echo %TEXT%Current power scheme:%RESET%
echo.

powercfg /list

echo.
echo %TEXT%Active scheme details:%RESET%
echo.

powercfg /query

echo.
echo %HEADER%%SEPARATOR%%RESET%
echo.
echo %BRACKET%[%RESET%%TEXT%0%RESET%%BRACKET%]%RESET% %TEXT%Back to Power Menu%RESET%
echo.
choice /c 0 /n /m ""
goto PowerMenu

:SleepStudy
cls
echo.
echo %HEADER%%SEPARATOR%%RESET%
echo %HEADER%            SLEEP STUDY%RESET%
echo %HEADER%%SEPARATOR%%RESET%
echo.

REM Check for admin rights
net session >nul 2>&1
if errorlevel 1 (
    echo %ERROR%Administrator privileges required!%RESET%
    echo %TEXT%Please run this launcher as Administrator.%RESET%
    echo.
    pause
    goto PowerMenu
)

set "REPORT_FILE=%~dp0..\logs\sleepstudy-report-%DATE:/=-%_%TIME::=-%.html"
set "REPORT_FILE=!REPORT_FILE: =_!"

echo %TEXT%Generating sleep study report...%RESET%
echo %TEXT%This analyzes recent sleep/wake sessions.%RESET%
echo.

powercfg /sleepstudy /output "!REPORT_FILE!" >nul 2>&1

if errorlevel 1 (
    echo %ERROR%Failed to generate report!%RESET%
    echo %TEXT%This feature may not be available on your device.%RESET%
) else (
    echo %SUCCESS%Sleep study report generated!%RESET%
    echo %TEXT%Location:%RESET% %BRACKET%!REPORT_FILE!%RESET%
    echo.
    echo %TEXT%Opening report in browser...%RESET%
    start "" "!REPORT_FILE!"
)

echo.
echo %BRACKET%[%RESET%%TEXT%0%RESET%%BRACKET%]%RESET% %TEXT%Back to Power Menu%RESET%
echo.
choice /c 0 /n /m ""
goto PowerMenu

:PowerScheme
cls
echo.
echo %HEADER%%SEPARATOR%%RESET%
echo %HEADER%           POWER SCHEME INFO%RESET%
echo %HEADER%%SEPARATOR%%RESET%
echo.

echo %TEXT%Available power schemes:%RESET%
echo.

powercfg /list

echo.
echo %TEXT%To change power scheme:%RESET%
echo %BRACKET%powercfg /setactive [GUID]%RESET%
echo.
echo %HEADER%%SEPARATOR%%RESET%
echo.
echo %BRACKET%[%RESET%%TEXT%0%RESET%%BRACKET%]%RESET% %TEXT%Back to Power Menu%RESET%
echo.
choice /c 0 /n /m ""
goto PowerMenu

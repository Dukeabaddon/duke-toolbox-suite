@echo off
setlocal enabledelayedexpansion

:: Duke Desktop Launcher - Network Diagnostics Module
:: Network troubleshooting and analysis tools

call "%~dp0colors.cmd"

:NetworkMenu
cls
echo.
echo %HEADER%%SEPARATOR%%RESET%
echo %HEADER%        NETWORK DIAGNOSTICS%RESET%
echo %HEADER%%SEPARATOR%%RESET%
echo.

echo %BRACKET%[%RESET%%TEXT%1%RESET%%BRACKET%]%RESET% %TEXT%IP Configuration (ipconfig)%RESET%
echo %BRACKET%[%RESET%%TEXT%2%RESET%%BRACKET%]%RESET% %TEXT%Flush DNS Cache%RESET%
echo %BRACKET%[%RESET%%TEXT%3%RESET%%BRACKET%]%RESET% %TEXT%Network Connections (netstat)%RESET%
echo %BRACKET%[%RESET%%TEXT%4%RESET%%BRACKET%]%RESET% %TEXT%Trace Route%RESET%
echo %BRACKET%[%RESET%%TEXT%5%RESET%%BRACKET%]%RESET% %TEXT%Path Ping (Advanced)%RESET%
echo %BRACKET%[%RESET%%TEXT%6%RESET%%BRACKET%]%RESET% %TEXT%Test Connection (ping)%RESET%
echo %BRACKET%[%RESET%%TEXT%7%RESET%%BRACKET%]%RESET% %TEXT%Release/Renew IP%RESET%
echo %BRACKET%[%RESET%%TEXT%8%RESET%%BRACKET%]%RESET% %TEXT%View Network Adapters%RESET%
echo.
echo %BRACKET%[%RESET%%TEXT%0%RESET%%BRACKET%]%RESET% %TEXT%Back to Main Menu%RESET%
echo.
echo %HEADER%%SEPARATOR%%RESET%
echo.

set /p "CHOICE=%BRACKET%[%RESET%%TEXT%?%RESET%%BRACKET%]%RESET% %TEXT%Select option: %RESET%"

if "%CHOICE%"=="0" exit /b 0
if "%CHOICE%"=="1" goto ShowIPConfig
if "%CHOICE%"=="2" goto FlushDNS
if "%CHOICE%"=="3" goto ShowNetstat
if "%CHOICE%"=="4" goto TraceRoute
if "%CHOICE%"=="5" goto PathPing
if "%CHOICE%"=="6" goto TestPing
if "%CHOICE%"=="7" goto RenewIP
if "%CHOICE%"=="8" goto ShowAdapters

echo %ERROR%Invalid selection!%RESET%
timeout /t 2 >nul
goto NetworkMenu

:ShowIPConfig
cls
echo.
echo %HEADER%%SEPARATOR%%RESET%
echo %HEADER%           IP CONFIGURATION%RESET%
echo %HEADER%%SEPARATOR%%RESET%
echo.

ipconfig /all

echo.
echo %HEADER%%SEPARATOR%%RESET%
echo.

set /p "SAVE=%BRACKET%[%RESET%%TEXT%?%RESET%%BRACKET%]%RESET% %TEXT%Save to log file? (Y/N): %RESET%"
if /i "%SAVE%"=="Y" (
    set "LOGFILE=%~dp0..\logs\ipconfig-%DATE:/=-%_%TIME::=-%"
    set "LOGFILE=!LOGFILE: =_!.txt"
    ipconfig /all > "!LOGFILE!"
    echo %SUCCESS%Saved to: !LOGFILE!%RESET%
    echo.
)

pause
goto NetworkMenu

:FlushDNS
cls
echo.
echo %HEADER%%SEPARATOR%%RESET%
echo %HEADER%             FLUSH DNS CACHE%RESET%
echo %HEADER%%SEPARATOR%%RESET%
echo.

echo %TEXT%Flushing DNS resolver cache...%RESET%
ipconfig /flushdns

echo.
echo %SUCCESS%DNS cache flushed successfully!%RESET%
echo.
pause
goto NetworkMenu

:ShowNetstat
cls
echo.
echo %HEADER%%SEPARATOR%%RESET%
echo %HEADER%        ACTIVE NETWORK CONNECTIONS%RESET%
echo %HEADER%%SEPARATOR%%RESET%
echo.

echo %TEXT%Select display mode:%RESET%
echo.
echo %BRACKET%[%RESET%%TEXT%1%RESET%%BRACKET%]%RESET% %TEXT%All connections%RESET%
echo %BRACKET%[%RESET%%TEXT%2%RESET%%BRACKET%]%RESET% %TEXT%Listening ports only%RESET%
echo %BRACKET%[%RESET%%TEXT%3%RESET%%BRACKET%]%RESET% %TEXT%Established connections%RESET%
echo %BRACKET%[%RESET%%TEXT%0%RESET%%BRACKET%]%RESET% %TEXT%Cancel%RESET%
echo.

set /p "NET_CHOICE=%BRACKET%[%RESET%%TEXT%?%RESET%%BRACKET%]%RESET% %TEXT%Select: %RESET%"

if "%NET_CHOICE%"=="0" goto NetworkMenu

cls
echo.
echo %HEADER%%SEPARATOR%%RESET%

if "%NET_CHOICE%"=="1" (
    echo %HEADER%           ALL CONNECTIONS%RESET%
    echo %HEADER%%SEPARATOR%%RESET%
    echo.
    netstat -an
) else if "%NET_CHOICE%"=="2" (
    echo %HEADER%          LISTENING PORTS%RESET%
    echo %HEADER%%SEPARATOR%%RESET%
    echo.
    netstat -an | findstr "LISTENING"
) else if "%NET_CHOICE%"=="3" (
    echo %HEADER%       ESTABLISHED CONNECTIONS%RESET%
    echo %HEADER%%SEPARATOR%%RESET%
    echo.
    netstat -an | findstr "ESTABLISHED"
)

echo.
echo %HEADER%%SEPARATOR%%RESET%
echo.
pause
goto NetworkMenu

:TraceRoute
cls
echo.
echo %HEADER%%SEPARATOR%%RESET%
echo %HEADER%              TRACE ROUTE%RESET%
echo %HEADER%%SEPARATOR%%RESET%
echo.

set /p "TARGET=%BRACKET%[%RESET%%TEXT%?%RESET%%BRACKET%]%RESET% %TEXT%Enter host (e.g., google.com): %RESET%"

if "%TARGET%"=="" (
    echo %ERROR%No target specified!%RESET%
    timeout /t 2 >nul
    goto NetworkMenu
)

echo.
echo %TEXT%Tracing route to %TARGET%...%RESET%
echo.

tracert %TARGET%

echo.
echo %HEADER%%SEPARATOR%%RESET%
echo.
pause
goto NetworkMenu

:PathPing
cls
echo.
echo %HEADER%%SEPARATOR%%RESET%
echo %HEADER%         PATH PING (ADVANCED)%RESET%
echo %HEADER%%SEPARATOR%%RESET%
echo.

echo %WARNING%Note: This may take several minutes...%RESET%
echo.

set /p "TARGET=%BRACKET%[%RESET%%TEXT%?%RESET%%BRACKET%]%RESET% %TEXT%Enter host (e.g., google.com): %RESET%"

if "%TARGET%"=="" (
    echo %ERROR%No target specified!%RESET%
    timeout /t 2 >nul
    goto NetworkMenu
)

echo.
echo %TEXT%Running path ping to %TARGET%...%RESET%
echo %TEXT%This will take approximately 2 minutes.%RESET%
echo.

pathping %TARGET%

echo.
echo %HEADER%%SEPARATOR%%RESET%
echo.
pause
goto NetworkMenu

:TestPing
cls
echo.
echo %HEADER%%SEPARATOR%%RESET%
echo %HEADER%            TEST CONNECTION%RESET%
echo %HEADER%%SEPARATOR%%RESET%
echo.

set /p "TARGET=%BRACKET%[%RESET%%TEXT%?%RESET%%BRACKET%]%RESET% %TEXT%Enter host (e.g., 8.8.8.8 or google.com): %RESET%"

if "%TARGET%"=="" (
    echo %ERROR%No target specified!%RESET%
    timeout /t 2 >nul
    goto NetworkMenu
)

echo.
echo %TEXT%Pinging %TARGET%...%RESET%
echo.

ping -n 4 %TARGET%

echo.
echo %HEADER%%SEPARATOR%%RESET%
echo.
pause
goto NetworkMenu

:RenewIP
cls
echo.
echo %HEADER%%SEPARATOR%%RESET%
echo %HEADER%           RELEASE/RENEW IP%RESET%
echo %HEADER%%SEPARATOR%%RESET%
echo.

echo %WARNING%This will temporarily disconnect you from the network.%RESET%
echo.

set /p "CONFIRM=%BRACKET%[%RESET%%TEXT%?%RESET%%BRACKET%]%RESET% %TEXT%Continue? (Y/N): %RESET%"

if /i not "%CONFIRM%"=="Y" goto NetworkMenu

echo.
echo %TEXT%Releasing IP address...%RESET%
ipconfig /release

echo.
echo %TEXT%Renewing IP address...%RESET%
ipconfig /renew

echo.
echo %SUCCESS%IP address renewed!%RESET%
echo.
pause
goto NetworkMenu

:ShowAdapters
cls
echo.
echo %HEADER%%SEPARATOR%%RESET%
echo %HEADER%          NETWORK ADAPTERS%RESET%
echo %HEADER%%SEPARATOR%%RESET%
echo.

echo %TEXT%Active network adapters:%RESET%
echo.

powershell -NoProfile -Command "Get-NetAdapter | Format-Table Name,Status,LinkSpeed,MacAddress -AutoSize"

echo.
echo %HEADER%%SEPARATOR%%RESET%
echo.
pause
goto NetworkMenu

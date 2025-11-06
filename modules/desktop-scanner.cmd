@echo off
setlocal enabledelayedexpansion

call "%~dp0colors.cmd"

:ScanDesktop
cls
call "%~dp0browser-detector.cmd"

set "CONFIG_FILE=%~dp0..\config\detected-browsers.txt"
if exist "%CONFIG_FILE%" (
    for /f "usebackq tokens=1* delims==" %%a in ("%CONFIG_FILE%") do set "%%a=%%b"
)

echo %HEADER%============================================================%C_RESET%
echo %HEADER%                  DESKTOP SCANNER%C_RESET%
echo %HEADER%============================================================%C_RESET%
echo.

set "DESKTOP=%USERPROFILE%\Desktop"
set /a "SHORTCUT_COUNT=0"
set /a "FOLDER_COUNT=0"
set /a "FILE_COUNT=0"

echo %TEXT%Scanning: %INFO%%DESKTOP%%C_RESET%
echo.

echo %SEPARATOR%-------------------------------------------------------------%C_RESET%
echo %HEADER%  SHORTCUTS%C_RESET%
echo %SEPARATOR%-------------------------------------------------------------%C_RESET%
for %%f in ("%DESKTOP%\*.lnk") do (
    set /a "SHORTCUT_COUNT+=1"
    echo   %BRACKET%+%C_RESET% %TEXT%%%~nf%C_RESET%
)
if !SHORTCUT_COUNT! equ 0 echo   %WARNING%No shortcuts found%C_RESET%

echo.
echo %SEPARATOR%-------------------------------------------------------------%C_RESET%
echo %HEADER%  FOLDERS%C_RESET%
echo %SEPARATOR%-------------------------------------------------------------%C_RESET%
for /d %%d in ("%DESKTOP%\*") do (
    set /a "FOLDER_COUNT+=1"
    echo   %BRACKET%[DIR]%C_RESET% %TEXT%%%~nd\%C_RESET%
)
if !FOLDER_COUNT! equ 0 echo   %WARNING%No folders found%C_RESET%

echo.
echo %SEPARATOR%-------------------------------------------------------------%C_RESET%
echo %HEADER%  FILES%C_RESET%
echo %SEPARATOR%-------------------------------------------------------------%C_RESET%
for %%f in ("%DESKTOP%\*") do (
    set "EXTENSION=%%~xf"
    if not "!EXTENSION!"==".lnk" if not "!EXTENSION!"==".ini" (
        set /a "FILE_COUNT+=1"
        echo   %TEXT%%%~nxf%C_RESET%
    )
)
if !FILE_COUNT! equ 0 echo   %WARNING%No other files found%C_RESET%

echo.
echo %SEPARATOR%-------------------------------------------------------------%C_RESET%
set /a "TOTAL_ITEMS=SHORTCUT_COUNT+FOLDER_COUNT+FILE_COUNT"
echo   %SUCCESS%Total: !TOTAL_ITEMS! items%C_RESET% %BRACKET%(!SHORTCUT_COUNT! shortcuts, !FOLDER_COUNT! folders, !FILE_COUNT! files)%C_RESET%
echo %SEPARATOR%-------------------------------------------------------------%C_RESET%

echo.
echo %HEADER%  DETECTED BROWSERS%C_RESET%
echo %SEPARATOR%-------------------------------------------------------------%C_RESET%
set "BROWSER_FOUND=0"

if defined BRAVE_PATH (
    echo   %SUCCESS%[OK]%C_RESET% %TEXT%Brave Browser%C_RESET%
    set "BROWSER_FOUND=1"
)
if defined CHROME_PATH (
    echo   %SUCCESS%[OK]%C_RESET% %TEXT%Google Chrome%C_RESET%
    set "BROWSER_FOUND=1"
)
if defined EDGE_PATH (
    echo   %SUCCESS%[OK]%C_RESET% %TEXT%Microsoft Edge%C_RESET%
    set "BROWSER_FOUND=1"
)
if defined FIREFOX_PATH (
    echo   %SUCCESS%[OK]%C_RESET% %TEXT%Mozilla Firefox%C_RESET%
    set "BROWSER_FOUND=1"
)
if defined OPERA_PATH (
    echo   %SUCCESS%[OK]%C_RESET% %TEXT%Opera%C_RESET%
    set "BROWSER_FOUND=1"
)

if !BROWSER_FOUND! equ 0 echo   %ERROR%No browsers detected%C_RESET%
echo %SEPARATOR%-------------------------------------------------------------%C_RESET%

echo.
echo %BRACKET%[0]%C_RESET% %TEXT%Back to Menu%C_RESET%
echo.
choice /c 0 /n /m ""
exit /b 0

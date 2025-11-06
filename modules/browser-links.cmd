@echo off
setlocal enabledelayedexpansion

:: Duke Desktop Launcher - Browser Quick Links Module
:: Displays and launches browser-specific quick links

call "%~dp0colors.cmd"

:: Load browser paths
set "BROWSER_CONFIG=%~dp0..\config\detected-browsers.txt"
if exist "%BROWSER_CONFIG%" (
    for /f "usebackq tokens=1* delims==" %%a in ("%BROWSER_CONFIG%") do set "%%a=%%b"
)

:BrowserMenu
cls
echo.
echo %HEADER%%SEPARATOR%%RESET%
echo %HEADER%           BROWSER QUICK LINKS%RESET%
echo %HEADER%%SEPARATOR%%RESET%
echo.

:: Count available browsers
set /a "BROWSER_COUNT=0"
set "BROWSER_NAMES="
set "BROWSER_PATHS="

if defined BRAVE_PATH (
    set /a "BROWSER_COUNT+=1"
    set "BROWSER_NAMES=!BROWSER_NAMES! Brave"
    set "BROWSER_PATHS=!BROWSER_PATHS!!BRAVE_PATH!|"
    echo %BRACKET%[%RESET%%TEXT%1%RESET%%BRACKET%]%RESET% %TEXT%Brave Browser%RESET%
)

if defined CHROME_PATH (
    set /a "BROWSER_COUNT+=1"
    set "BROWSER_NAMES=!BROWSER_NAMES! Chrome"
    set "BROWSER_PATHS=!BROWSER_PATHS!!CHROME_PATH!|"
    echo %BRACKET%[%RESET%%TEXT%2%RESET%%BRACKET%]%RESET% %TEXT%Google Chrome%RESET%
)

if defined EDGE_PATH (
    set /a "BROWSER_COUNT+=1"
    set "BROWSER_NAMES=!BROWSER_NAMES! Edge"
    set "BROWSER_PATHS=!BROWSER_PATHS!!EDGE_PATH!|"
    echo %BRACKET%[%RESET%%TEXT%3%RESET%%BRACKET%]%RESET% %TEXT%Microsoft Edge%RESET%
)

if defined FIREFOX_PATH (
    set /a "BROWSER_COUNT+=1"
    set "BROWSER_NAMES=!BROWSER_NAMES! Firefox"
    set "BROWSER_PATHS=!BROWSER_PATHS!!FIREFOX_PATH!|"
    echo %BRACKET%[%RESET%%TEXT%4%RESET%%BRACKET%]%RESET% %TEXT%Mozilla Firefox%RESET%
)

if defined OPERA_PATH (
    set /a "BROWSER_COUNT+=1"
    set "BROWSER_NAMES=!BROWSER_NAMES! Opera"
    set "BROWSER_PATHS=!BROWSER_PATHS!!OPERA_PATH!|"
    echo %BRACKET%[%RESET%%TEXT%5%RESET%%BRACKET%]%RESET% %TEXT%Opera%RESET%
)

echo.
echo %BRACKET%[%RESET%%TEXT%E%RESET%%BRACKET%]%RESET% %TEXT%Edit Quick Links%RESET%
echo %BRACKET%[%RESET%%TEXT%0%RESET%%BRACKET%]%RESET% %TEXT%Back to Main Menu%RESET%
echo.
echo %HEADER%%SEPARATOR%%RESET%
echo.

if !BROWSER_COUNT! equ 0 (
    echo %ERROR%No browsers detected!%RESET%
    echo %TEXT%Please install a supported browser.%RESET%
    echo.
    pause
    exit /b 0
)

set /p "CHOICE=%BRACKET%[%RESET%%TEXT%?%RESET%%BRACKET%]%RESET% %TEXT%Select browser: %RESET%"

if /i "%CHOICE%"=="0" exit /b 0
if /i "%CHOICE%"=="E" (
    call :EditLinks
    goto BrowserMenu
)

:: Determine which browser was selected
set "SELECTED_BROWSER="
set "SELECTED_PATH="
set "LINKS_FILE="

if "%CHOICE%"=="1" if defined BRAVE_PATH (
    set "SELECTED_BROWSER=Brave"
    set "SELECTED_PATH=%BRAVE_PATH%"
    set "LINKS_FILE=%~dp0..\config\brave-links.txt"
)
if "%CHOICE%"=="2" if defined CHROME_PATH (
    set "SELECTED_BROWSER=Chrome"
    set "SELECTED_PATH=%CHROME_PATH%"
    set "LINKS_FILE=%~dp0..\config\chrome-links.txt"
)
if "%CHOICE%"=="3" if defined EDGE_PATH (
    set "SELECTED_BROWSER=Edge"
    set "SELECTED_PATH=%EDGE_PATH%"
    set "LINKS_FILE=%~dp0..\config\edge-links.txt"
)
if "%CHOICE%"=="4" if defined FIREFOX_PATH (
    set "SELECTED_BROWSER=Firefox"
    set "SELECTED_PATH=%FIREFOX_PATH%"
    set "LINKS_FILE=%~dp0..\config\firefox-links.txt"
)
if "%CHOICE%"=="5" if defined OPERA_PATH (
    set "SELECTED_BROWSER=Opera"
    set "SELECTED_PATH=%OPERA_PATH%"
    set "LINKS_FILE=%~dp0..\config\opera-links.txt"
)

if not defined SELECTED_BROWSER (
    echo %ERROR%Invalid selection!%RESET%
    timeout /t 2 >nul
    goto BrowserMenu
)

:: Show links for selected browser
call :ShowLinks "%SELECTED_BROWSER%" "%SELECTED_PATH%" "%LINKS_FILE%"
goto BrowserMenu

:ShowLinks
setlocal
set "BROWSER_NAME=%~1"
set "BROWSER_PATH=%~2"
set "LINKS_FILE=%~3"

:LinksMenu
cls
echo.
echo %HEADER%%SEPARATOR%%RESET%
echo %HEADER%              %BROWSER_NAME% QUICK LINKS%RESET%
echo %HEADER%%SEPARATOR%%RESET%
echo.

:: Check if links file exists, create from template if not
if not exist "%LINKS_FILE%" (
    echo %WARNING%Links file not found. Creating from template...%RESET%
    copy "%~dp0..\config\TEMPLATE-browser-links.txt" "%LINKS_FILE%" >nul 2>&1
    if errorlevel 1 (
        echo %ERROR%Failed to create links file!%RESET%
        pause
        exit /b 1
    )
    echo %SUCCESS%Created: %LINKS_FILE%%RESET%
    echo.
)

:: Load links from file
set /a "LINK_COUNT=0"
for /f "usebackq tokens=1* delims=|" %%a in ("%LINKS_FILE%") do (
    set "LINE=%%a"
    :: Skip comments and empty lines
    if not "!LINE:~0,1!"=="#" if not "!LINE!"=="" (
        set /a "LINK_COUNT+=1"
        set "LINK_NAME[!LINK_COUNT!]=%%a"
        set "LINK_URL[!LINK_COUNT!]=%%b"
        echo %BRACKET%[%RESET%%TEXT%!LINK_COUNT!%RESET%%BRACKET%]%RESET% %TEXT%%%a%RESET%
    )
)

if !LINK_COUNT! equ 0 (
    echo %ERROR%No links configured!%RESET%
    echo %TEXT%Edit the links file to add URLs.%RESET%
    echo.
    echo %BRACKET%[%RESET%%TEXT%E%RESET%%BRACKET%]%RESET% %TEXT%Edit Links Now%RESET%
    echo %BRACKET%[%RESET%%TEXT%0%RESET%%BRACKET%]%RESET% %TEXT%Back%RESET%
    echo.
    set /p "CHOICE=%BRACKET%[%RESET%%TEXT%?%RESET%%BRACKET%]%RESET% %TEXT%Choice: %RESET%"
    if /i "!CHOICE!"=="E" (
        notepad "%LINKS_FILE%"
        goto LinksMenu
    )
    exit /b 0
)

echo.
echo %BRACKET%[%RESET%%TEXT%E%RESET%%BRACKET%]%RESET% %TEXT%Edit Links%RESET%
echo %BRACKET%[%RESET%%TEXT%0%RESET%%BRACKET%]%RESET% %TEXT%Back%RESET%
echo.
echo %HEADER%%SEPARATOR%%RESET%
echo.

set /p "CHOICE=%BRACKET%[%RESET%%TEXT%?%RESET%%BRACKET%]%RESET% %TEXT%Select link (1-%LINK_COUNT%): %RESET%"

if /i "%CHOICE%"=="0" exit /b 0
if /i "%CHOICE%"=="E" (
    notepad "%LINKS_FILE%"
    goto LinksMenu
)

:: Validate numeric choice
set "VALID=0"
for /l %%i in (1,1,!LINK_COUNT!) do (
    if "%CHOICE%"=="%%i" set "VALID=1"
)

if !VALID! equ 0 (
    echo %ERROR%Invalid selection!%RESET%
    timeout /t 2 >nul
    goto LinksMenu
)

:: Launch URL in selected browser
echo %SUCCESS%Opening: !LINK_NAME[%CHOICE%]!%RESET%
start "" "%BROWSER_PATH%" "!LINK_URL[%CHOICE%]!"
timeout /t 1 >nul
goto LinksMenu

:EditLinks
cls
echo.
echo %HEADER%%SEPARATOR%%RESET%
echo %HEADER%             EDIT QUICK LINKS%RESET%
echo %HEADER%%SEPARATOR%%RESET%
echo.

echo %TEXT%Select browser to edit links:%RESET%
echo.

set /a "EDIT_COUNT=0"

if defined BRAVE_PATH (
    set /a "EDIT_COUNT+=1"
    echo %BRACKET%[%RESET%%TEXT%1%RESET%%BRACKET%]%RESET% %TEXT%Brave Browser%RESET% %BRACKET%(%RESET%%TEXT%brave-links.txt%RESET%%BRACKET%)%RESET%
)
if defined CHROME_PATH (
    set /a "EDIT_COUNT+=1"
    echo %BRACKET%[%RESET%%TEXT%2%RESET%%BRACKET%]%RESET% %TEXT%Google Chrome%RESET% %BRACKET%(%RESET%%TEXT%chrome-links.txt%RESET%%BRACKET%)%RESET%
)
if defined EDGE_PATH (
    set /a "EDIT_COUNT+=1"
    echo %BRACKET%[%RESET%%TEXT%3%RESET%%BRACKET%]%RESET% %TEXT%Microsoft Edge%RESET% %BRACKET%(%RESET%%TEXT%edge-links.txt%RESET%%BRACKET%)%RESET%
)
if defined FIREFOX_PATH (
    set /a "EDIT_COUNT+=1"
    echo %BRACKET%[%RESET%%TEXT%4%RESET%%BRACKET%]%RESET% %TEXT%Mozilla Firefox%RESET% %BRACKET%(%RESET%%TEXT%firefox-links.txt%RESET%%BRACKET%)%RESET%
)
if defined OPERA_PATH (
    set /a "EDIT_COUNT+=1"
    echo %BRACKET%[%RESET%%TEXT%5%RESET%%BRACKET%]%RESET% %TEXT%Opera%RESET% %BRACKET%(%RESET%%TEXT%opera-links.txt%RESET%%BRACKET%)%RESET%
)

echo.
echo %BRACKET%[%RESET%%TEXT%0%RESET%%BRACKET%]%RESET% %TEXT%Back%RESET%
echo.
echo %HEADER%%SEPARATOR%%RESET%
echo.

set /p "EDIT_CHOICE=%BRACKET%[%RESET%%TEXT%?%RESET%%BRACKET%]%RESET% %TEXT%Select: %RESET%"

if "%EDIT_CHOICE%"=="0" exit /b 0

set "EDIT_FILE="
if "%EDIT_CHOICE%"=="1" if defined BRAVE_PATH set "EDIT_FILE=%~dp0..\config\brave-links.txt"
if "%EDIT_CHOICE%"=="2" if defined CHROME_PATH set "EDIT_FILE=%~dp0..\config\chrome-links.txt"
if "%EDIT_CHOICE%"=="3" if defined EDGE_PATH set "EDIT_FILE=%~dp0..\config\edge-links.txt"
if "%EDIT_CHOICE%"=="4" if defined FIREFOX_PATH set "EDIT_FILE=%~dp0..\config\firefox-links.txt"
if "%EDIT_CHOICE%"=="5" if defined OPERA_PATH set "EDIT_FILE=%~dp0..\config\opera-links.txt"

if not defined EDIT_FILE (
    echo %ERROR%Invalid selection!%RESET%
    timeout /t 2 >nul
    goto EditLinks
)

:: Create from template if doesn't exist
if not exist "%EDIT_FILE%" (
    echo %WARNING%File doesn't exist. Creating from template...%RESET%
    copy "%~dp0..\config\TEMPLATE-browser-links.txt" "%EDIT_FILE%" >nul 2>&1
    echo %SUCCESS%Created: %EDIT_FILE%%RESET%
    echo.
    timeout /t 2 >nul
)

:: Open in Notepad
notepad "%EDIT_FILE%"
exit /b 0

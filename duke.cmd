@echo off
setlocal enabledelayedexpansion
title DUKE DESKTOP LAUNCHER v1.0

REM ============================================================
REM DUKE DESKTOP LAUNCHER - Main Entry Point
REM Ghost Toolbox inspired desktop launcher
REM ============================================================

REM Initialize color system
call "%~dp0modules\colors.cmd"

REM Show ASCII banner FIRST (always, animated)
call :ShowASCIIBanner

REM Check if first-time setup is needed
if not exist "%~dp0config\user-settings.txt" (
    call :FirstTimeSetup
) else (
    REM Load user settings and show greeting
    for /f "usebackq tokens=1,* delims==" %%a in ("%~dp0config\user-settings.txt") do set "%%a=%%b"
    call :ShowGreeting
)

REM Detect system info on first run
if not exist "%~dp0config\system-info.txt" (
    call :DetectSystemInfo
)

REM Detect browsers
call "%~dp0modules\browser-detector.cmd"

REM Main program loop
:MainMenu
call :ShowMainMenu
call :HandleMenuChoice
goto MainMenu

REM ============================================================
REM ASCII BANNER (ALWAYS SHOWN FIRST)
REM ============================================================
:ShowASCIIBanner
cls

REM Display ASCII banner with smooth fast animation
for /f "usebackq delims=" %%a in ("%~dp0assets\banner.txt") do (
    echo %HEADER%%%a%C_RESET%
    ping localhost -n 1 -w 20 >nul 2>&1
)

echo.
timeout /t 1 >nul
cls
goto :eof

REM ============================================================
REM FIRST-TIME SETUP WIZARD (NAME ONLY)
REM ============================================================
:FirstTimeSetup
echo %HEADER%============================================================%C_RESET%
echo %HEADER%          DUKE DESKTOP LAUNCHER - FIRST TIME SETUP%C_RESET%
echo %HEADER%============================================================%C_RESET%
echo.
echo %TEXT%Welcome! Let's configure your launcher.%C_RESET%
echo.

REM Ask for username with input sanitization
:AskUsername
set "USERNAME="
set /p "USERNAME=%TEXT%Enter your name:%C_RESET% "

REM Sanitize username (remove dangerous characters)
if defined USERNAME (
    call :SanitizeUsernameInline
)

if "!USERNAME!"=="" (
    echo %WARNING%Name cannot be empty. Please try again.%C_RESET%
    goto :AskUsername
)

REM Save settings
echo USERNAME=!USERNAME! > "%~dp0config\user-settings.txt"

echo.
echo %SUCCESS%Setup complete! Launching Duke Desktop Launcher...%C_RESET%
timeout /t 2 >nul

REM Reload username
for /f "usebackq tokens=1,* delims==" %%a in ("%~dp0config\user-settings.txt") do set "%%a=%%b"

REM Show greeting
call :ShowGreeting
goto :eof

REM ============================================================
REM GREETING (SUBSEQUENT LAUNCHES)
REM ============================================================
:ShowGreeting
echo.
echo.
echo %SUCCESS%              Welcome back, %USERNAME%!%C_RESET%
echo.
echo.
timeout /t 3 >nul
cls
goto :eof

REM ============================================================
REM SANITIZE USERNAME (prevent command injection)
REM ============================================================
:SanitizeUsernameInline
REM Remove dangerous characters from USERNAME variable
set "USERNAME=%USERNAME:&=%"
set "USERNAME=%USERNAME:|=%"
set "USERNAME=%USERNAME:>=%"
set "USERNAME=%USERNAME:<=%"
set "USERNAME=%USERNAME:^=%"
set "USERNAME=%USERNAME:;=%"
set "USERNAME=%USERNAME:`=%"
set "USERNAME=%USERNAME:$=%"
set "USERNAME=%USERNAME:(=%"
set "USERNAME=%USERNAME:)=%"
set "USERNAME=%USERNAME:!=%"
set "USERNAME=%USERNAME:@=%"
set "USERNAME=%USERNAME:#=%"
goto :eof

REM Old function kept for compatibility
:SanitizeUsername
set "INPUT=%~1"
set "SANITIZED_NAME="

REM Remove dangerous characters
set "INPUT=%INPUT:&=%"
set "INPUT=%INPUT:|=%"
set "INPUT=%INPUT:>=%"
set "INPUT=%INPUT:<=%"
set "INPUT=%INPUT:^=%"
set "INPUT=%INPUT:;=%"
set "INPUT=%INPUT:`=%"
set "INPUT=%INPUT:$=%"
set "INPUT=%INPUT:(=%"
set "INPUT=%INPUT:)=%"
set "INPUT=%INPUT:!=%"
set "INPUT=%INPUT:@=%"
set "INPUT=%INPUT:#=%"
set "INPUT=%INPUT:%%=%"

REM Keep only alphanumeric and spaces
for /f "tokens=*" %%a in ("%INPUT%") do set "SANITIZED_NAME=%%a"

exit /b 0

REM ============================================================
REM DETECT WINDOW WIDTH (dynamic header sizing)
REM ============================================================
:DetectWindowWidth
REM Get CMD window width via PowerShell
for /f %%a in ('powershell -NoProfile -Command "$Host.UI.RawUI.WindowSize.Width"') do set "WINDOW_WIDTH=%%a"

REM Fallback to 120 if detection fails
if not defined WINDOW_WIDTH set "WINDOW_WIDTH=120"
if %WINDOW_WIDTH% lss 60 set "WINDOW_WIDTH=120"

REM Generate dynamic separator
set "DYNAMIC_SEP="
for /l %%i in (1,1,%WINDOW_WIDTH%) do set "DYNAMIC_SEP=!DYNAMIC_SEP!="

exit /b 0

REM ============================================================
REM MAIN MENU DISPLAY (TWO-COLUMN LAYOUT)
REM ============================================================
:ShowMainMenu
cls

REM Detect window width for dynamic headers
call :DetectWindowWidth

REM Load system info
for /f "usebackq tokens=1,* delims==" %%a in ("%~dp0config\system-info.txt") do set "%%a=%%b"

REM Load browser paths
if exist "%~dp0config\detected-browsers.txt" (
    for /f "usebackq tokens=1,* delims==" %%a in ("%~dp0config\detected-browsers.txt") do set "%%a=%%b"
)

REM Dynamic header with system info
echo %HEADER%!DYNAMIC_SEP!%C_RESET%

REM Calculate padding for centered title
set "TITLE=DUKE DESKTOP LAUNCHER"
set /a "TITLE_LEN=20"
set /a "PADDING=(!WINDOW_WIDTH! - !TITLE_LEN!) / 2"
set "TITLE_PAD="
for /l %%i in (1,1,!PADDING!) do set "TITLE_PAD=!TITLE_PAD! "

echo %HEADER%!TITLE_PAD!!TITLE!%C_RESET%
echo %HEADER%!DYNAMIC_SEP!%C_RESET%
echo %TEXT%OS: %SYS_OS% ^| Timezone: %SYS_TIMEZONE% ^| User: %USERNAME%%C_RESET%
echo %TEXT%CPU: %SYS_CPU% ^| RAM: %SYS_RAM%%C_RESET%
echo %HEADER%!DYNAMIC_SEP!%C_RESET%
echo.

REM Two-column layout with dynamic spacing
set /a "COL_WIDTH=(!WINDOW_WIDTH! - 4) / 2"
set /a "LEFT_PAD=2"

echo %HEADER%APPLICATIONS ^| DESKTOP          UTILITIES ^| EXTRAS%C_RESET%
set "COL_SEP="
for /l %%i in (1,1,%WINDOW_WIDTH%) do set "COL_SEP=!COL_SEP!-"
echo %SEPARATOR%!COL_SEP!%C_RESET%

REM Show installed browsers only
if defined BRAVE_PATH echo %BRACKET%[1]%C_RESET%  %TEXT%^| Brave Browser%C_RESET%            %BRACKET%[10]%C_RESET% %TEXT%^| Weather Display%C_RESET%
if defined CHROME_PATH echo %BRACKET%[2]%C_RESET%  %TEXT%^| Chrome Browser%C_RESET%           %BRACKET%[11]%C_RESET% %TEXT%^| Random Quote%C_RESET%
if defined EDGE_PATH echo %BRACKET%[3]%C_RESET%  %TEXT%^| Edge Browser%C_RESET%             %BRACKET%[12]%C_RESET% %TEXT%^| System Health Check%C_RESET%
if defined FIREFOX_PATH echo %BRACKET%[4]%C_RESET%  %TEXT%^| Firefox Browser%C_RESET%          %BRACKET%[13]%C_RESET% %TEXT%^| Network Diagnostics%C_RESET%

echo %BRACKET%[5]%C_RESET%  %TEXT%^| Spotify%C_RESET%                  %BRACKET%[14]%C_RESET% %TEXT%^| Power Report%C_RESET%
echo %BRACKET%[6]%C_RESET%  %TEXT%^| Matrix Rain%C_RESET%              %BRACKET%[15]%C_RESET% %TEXT%^| Disk Space Analyzer%C_RESET%
echo %BRACKET%[7]%C_RESET%  %TEXT%^| Tetris Game%C_RESET%              
echo %BRACKET%[8]%C_RESET%  %TEXT%^| Snake Game%C_RESET%
echo %BRACKET%[9]%C_RESET%  %TEXT%^| Desktop Scanner%C_RESET%          

echo.
echo %HEADER%SETTINGS ^| ETC%C_RESET%
echo %SEPARATOR%!COL_SEP!%C_RESET%
echo %BRACKET%[18]%C_RESET% %TEXT%^| Personalization%C_RESET%
echo %BRACKET%[19]%C_RESET% %TEXT%^| About%C_RESET%
echo.
echo %BRACKET%[0]%C_RESET%  %TEXT%^| Exit%C_RESET%
echo %SEPARATOR%!COL_SEP!%C_RESET%
echo.
set /p "choice=%TEXT%Type option:%C_RESET% "
echo.
goto :eof

REM ============================================================
REM HANDLE MENU CHOICES
REM ============================================================
:HandleMenuChoice
if "%choice%"=="0" goto Exit

REM Browsers (with submenus)
if "%choice%"=="1" if defined BRAVE_PATH call :BrowserSubmenu "Brave" "%BRAVE_PATH%" "brave-links.txt" & goto :eof
if "%choice%"=="2" if defined CHROME_PATH call :BrowserSubmenu "Chrome" "%CHROME_PATH%" "chrome-links.txt" & goto :eof
if "%choice%"=="3" if defined EDGE_PATH call :BrowserSubmenu "Edge" "%EDGE_PATH%" "edge-links.txt" & goto :eof
if "%choice%"=="4" if defined FIREFOX_PATH call :BrowserSubmenu "Firefox" "%FIREFOX_PATH%" "firefox-links.txt" & goto :eof

REM Applications
if "%choice%"=="5" call :SpotifySubmenu & goto :eof
if "%choice%"=="6" call modules\matrix-rain.cmd & goto :eof
if "%choice%"=="7" call modules\tetris.cmd & goto :eof
if "%choice%"=="8" call modules\snake.cmd & goto :eof
if "%choice%"=="9" call modules\desktop-scanner.cmd & goto :eof

REM Utilities
if "%choice%"=="10" call modules\weather.cmd & goto :eof
if "%choice%"=="11" call modules\quotes.cmd & goto :eof
if "%choice%"=="12" call modules\system-health.cmd & goto :eof
if "%choice%"=="13" call modules\network-diagnostics.cmd & goto :eof
if "%choice%"=="14" call modules\power-report.cmd & goto :eof
if "%choice%"=="15" call modules\disk-analyzer.cmd & goto :eof

REM Settings
if "%choice%"=="18" call :PersonalizationMenu & goto :eof
if "%choice%"=="19" call :ShowAbout & goto :eof

echo %ERROR%Invalid selection!%C_RESET%
timeout /t 2 >nul
goto :eof

REM ============================================================
REM BROWSER SUBMENU
REM ============================================================
:BrowserSubmenu
setlocal
set "BROWSER_NAME=%~1"
set "BROWSER_PATH=%~2"
set "LINKS_FILE=%~3"

:BrowserMenu
cls
echo %HEADER%============================================================%C_RESET%
echo %HEADER%                  %BROWSER_NAME% BROWSER%C_RESET%
echo %HEADER%============================================================%C_RESET%
echo.

REM Show Launch option
echo %BRACKET%[1]%C_RESET% %TEXT%Launch %BROWSER_NAME%%C_RESET%
echo.

REM Load and display quick links
set "FULL_PATH=%~dp0config\%LINKS_FILE%"
set /a "LINK_COUNT=0"

if exist "%FULL_PATH%" (
    for /f "usebackq tokens=1* delims=|" %%a in ("%FULL_PATH%") do (
        set "LINE=%%a"
        if not "!LINE:~0,1!"=="#" if not "!LINE!"=="" (
            set /a "LINK_COUNT+=1"
            set "LINK_NAME[!LINK_COUNT!]=%%a"
            set "LINK_URL[!LINK_COUNT!]=%%b"
            set /a "DISPLAY_NUM=!LINK_COUNT!+1"
            echo %BRACKET%[!DISPLAY_NUM!]%C_RESET% %TEXT%%%a%C_RESET%
        )
    )
)

if !LINK_COUNT! equ 0 (
    echo %TEXT%No quick links yet%C_RESET%
)

echo.
echo %SEPARATOR%------------------------------------------------------------%C_RESET%
set /a "EDIT_NUM=LINK_COUNT+2"
echo %BRACKET%[!EDIT_NUM!]%C_RESET% %TEXT%Edit Links%C_RESET%
echo %BRACKET%[0]%C_RESET% %TEXT%Back to Menu%C_RESET%
echo %SEPARATOR%------------------------------------------------------------%C_RESET%
echo.
set /p "BROWSER_CHOICE=%TEXT%Type option:%C_RESET% "

if "%BROWSER_CHOICE%"=="0" exit /b 0
if "%BROWSER_CHOICE%"=="1" (
    start "" "%BROWSER_PATH%"
    timeout /t 1 >nul
    goto BrowserMenu
)

REM Check if edit option
if "%BROWSER_CHOICE%"=="!EDIT_NUM!" (
    call :EditLinks "%LINKS_FILE%"
    goto BrowserMenu
)

REM Check if it's a quick link
set /a "LINK_INDEX=BROWSER_CHOICE-1"
if defined LINK_URL[!LINK_INDEX!] (
    start "" "%BROWSER_PATH%" "!LINK_URL[%LINK_INDEX%]!"
    timeout /t 1 >nul
    goto BrowserMenu
)

echo %ERROR%Invalid option!%C_RESET%
timeout /t 1 >nul
goto BrowserMenu

REM ============================================================
REM SHOW QUICK LINKS
REM ============================================================
:ShowQuickLinks
setlocal
set "BROWSER_NAME=%~1"
set "BROWSER_PATH=%~2"
set "LINKS_FILE=%~3"
set "FULL_PATH=%~dp0config\%LINKS_FILE%"

:QuickLinksMenu
cls
echo %HEADER%============================================================%C_RESET%
echo %HEADER%              %BROWSER_NAME% - QUICK LINKS%C_RESET%
echo %HEADER%============================================================%C_RESET%
echo.

if not exist "%FULL_PATH%" (
    echo %WARNING%No quick links configured yet.%C_RESET%
    echo %TEXT%Use option 3 to add links.%C_RESET%
    echo.
    pause
    exit /b 0
)

set /a "LINK_COUNT=0"
for /f "usebackq tokens=1* delims=|" %%a in ("%FULL_PATH%") do (
    set "LINE=%%a"
    if not "!LINE:~0,1!"=="#" if not "!LINE!"=="" (
        set /a "LINK_COUNT+=1"
        set "LINK_NAME[!LINK_COUNT!]=%%a"
        set "LINK_URL[!LINK_COUNT!]=%%b"
        echo %BRACKET%[!LINK_COUNT!]%C_RESET% %TEXT%%%a%C_RESET%
    )
)

if !LINK_COUNT! equ 0 (
    echo %WARNING%No links found.%C_RESET%
    echo.
    pause
    exit /b 0
)

echo.
echo %BRACKET%[0]%C_RESET% %TEXT%Back%C_RESET%
echo %SEPARATOR%------------------------------------------------------------%C_RESET%
echo.
set /p "LINK_CHOICE=%TEXT%Type option (1-%LINK_COUNT%):%C_RESET% "

if "%LINK_CHOICE%"=="0" exit /b 0

set "VALID=0"
for /l %%i in (1,1,!LINK_COUNT!) do if "%LINK_CHOICE%"=="%%i" set "VALID=1"

if !VALID! equ 0 (
    echo %ERROR%Invalid!%C_RESET%
    timeout /t 1 >nul
    goto QuickLinksMenu
)

echo %SUCCESS%Opening: !LINK_NAME[%LINK_CHOICE%]!%C_RESET%
start "" "%BROWSER_PATH%" "!LINK_URL[%LINK_CHOICE%]!"
timeout /t 1 >nul
goto QuickLinksMenu

REM ============================================================
REM EDIT LINKS (ADD/EDIT/DELETE)
REM ============================================================
:EditLinks
setlocal
set "LINKS_FILE=%~1"
set "FULL_PATH=%~dp0config\%LINKS_FILE%"

:EditMenu
cls
echo %HEADER%============================================================%C_RESET%
echo %HEADER%                    EDIT QUICK LINKS%C_RESET%
echo %HEADER%============================================================%C_RESET%
echo.

echo %BRACKET%[1]%C_RESET% %TEXT%Add New Link%C_RESET%
echo %BRACKET%[2]%C_RESET% %TEXT%Delete Link%C_RESET%
echo %BRACKET%[3]%C_RESET% %TEXT%View All Links%C_RESET%
echo.
echo %BRACKET%[0]%C_RESET% %TEXT%Back%C_RESET%
echo %SEPARATOR%------------------------------------------------------------%C_RESET%
echo.
set /p "EDIT_CHOICE=%TEXT%Type option:%C_RESET% "

if "%EDIT_CHOICE%"=="0" exit /b 0
if "%EDIT_CHOICE%"=="1" call :AddLink "%FULL_PATH%" & goto EditMenu
if "%EDIT_CHOICE%"=="2" call :DeleteLink "%FULL_PATH%" & goto EditMenu
if "%EDIT_CHOICE%"=="3" type "%FULL_PATH%" & echo. & pause & goto EditMenu

echo %ERROR%Invalid!%C_RESET%
timeout /t 1 >nul
goto EditMenu

REM Add new link
:AddLink
set "FILE=%~1"
echo.
set /p "LINK_NAME=%TEXT%Enter link name:%C_RESET% "
if "%LINK_NAME%"=="" echo %ERROR%Cancelled%C_RESET% & timeout /t 1 >nul & exit /b 0

REM Sanitize link name
call :SanitizeLinkName LINK_NAME

set /p "LINK_URL=%TEXT%Enter URL:%C_RESET% "
if "%LINK_URL%"=="" echo %ERROR%Cancelled%C_RESET% & timeout /t 1 >nul & exit /b 0

REM Validate URL
call :ValidateURL "%LINK_URL%"
if errorlevel 1 (
    echo %ERROR%Invalid URL! Must start with http:// or https://%C_RESET%
    timeout /t 2 >nul
    exit /b 1
)

REM Create file if it doesn't exist (no template)
if not exist "%FILE%" echo # Quick Links > "%FILE%"

REM Add link in format: Name|URL
echo %LINK_NAME%^|%LINK_URL% >> "%FILE%"
echo %SUCCESS%Link added: %LINK_NAME%%C_RESET%
timeout /t 1 >nul
exit /b 0

:DeleteLink
setlocal enabledelayedexpansion
set "LINKS_FILE=%~1"

if not exist "%LINKS_FILE%" (
    echo %ERROR%No links file found.%C_RESET%
    timeout /t 2 >nul
    exit /b 1
)

cls
echo %HEADER%============================================================%C_RESET%
echo %HEADER%                    DELETE LINK%C_RESET%
echo %HEADER%============================================================%C_RESET%
echo.

set count=0
for /f "usebackq tokens=1,* delims=|" %%a in ("%LINKS_FILE%") do (
    set "line=%%a|%%b"
    if not "!line:~0,1!"=="#" (
        set /a count+=1
        set "link_name_!count!=%%a"
        set "link_url_!count!=%%b"
    )
)

REM Display links
set idx=0
:DisplayLoop
set /a idx+=1
if !idx! GTR !count! goto AfterDisplay
call set "name=%%link_name_!idx!%%"
echo %BRACKET%[!idx!]%C_RESET% %TEXT%!name!%C_RESET%
goto DisplayLoop

:AfterDisplay

if %count%==0 (
    echo %WARNING%No links to delete.%C_RESET%
    timeout /t 2 >nul
    exit /b 0
)

echo.
echo %BRACKET%[0]%C_RESET% %TEXT%Cancel%C_RESET%
echo.
set /p "choice=%TEXT%Enter number to delete:%C_RESET% "

if "%choice%"=="0" exit /b 0

if not defined link_name_%choice% (
    echo %ERROR%Invalid selection.%C_RESET%
    timeout /t 2 >nul
    exit /b 1
)

set "TEMP_FILE=%TEMP%\duke-links-temp.txt"
call set "deleted_name=%%link_name_%choice%%%"

(
for /f "usebackq delims=" %%a in ("%LINKS_FILE%") do (
    set "line=%%a"
    set "skip=0"
    
    if not "!line:~0,1!"=="#" (
        for /f "tokens=1 delims=|" %%b in ("!line!") do (
            if "%%b"=="!deleted_name!" set "skip=1"
        )
    )
    
    if "!skip!"=="0" echo !line!
)
) > "%TEMP_FILE%"

move /y "%TEMP_FILE%" "%LINKS_FILE%" >nul

echo %SUCCESS%[OK] Deleted: %deleted_name%%C_RESET%
timeout /t 2 >nul
exit /b 0

REM ============================================================
REM SPOTIFY SUBMENU
REM ============================================================
:SpotifySubmenu
:SpotifyMenu
cls
echo %HEADER%============================================================%C_RESET%
echo %HEADER%                       SPOTIFY%C_RESET%
echo %HEADER%============================================================%C_RESET%
echo.

echo %BRACKET%[1]%C_RESET% %TEXT%Launch Spotify%C_RESET%
echo %BRACKET%[2]%C_RESET% %TEXT%Search Spotify%C_RESET%
echo %BRACKET%[3]%C_RESET% %TEXT%Open Web Player%C_RESET%
echo.
echo %BRACKET%[0]%C_RESET% %TEXT%Back%C_RESET%
echo %SEPARATOR%------------------------------------------------------------%C_RESET%
echo.
set /p "SPOT_CHOICE=%TEXT%Type option:%C_RESET% "

if "%SPOT_CHOICE%"=="0" exit /b 0
if "%SPOT_CHOICE%"=="1" start "" spotify: & timeout /t 1 >nul & goto SpotifyMenu
if "%SPOT_CHOICE%"=="2" (
    echo.
    set /p "QUERY=%TEXT%Search for:%C_RESET% "
    if not "!QUERY!"=="" (
        REM Sanitize search query
        call :SanitizeSearchQuery QUERY
        set "ENCODED=!QUERY: =+!"
        start "" "spotify:search:!ENCODED!"
    )
    timeout /t 1 >nul
    goto SpotifyMenu
)
if "%SPOT_CHOICE%"=="3" start "" "https://open.spotify.com" & timeout /t 1 >nul & goto SpotifyMenu

echo %ERROR%Invalid!%C_RESET%
timeout /t 1 >nul
goto SpotifyMenu

REM ============================================================
REM SYSTEM INFO AUTO-DETECTION
REM ============================================================
:DetectSystemInfo
echo %INFO%Detecting system information...%C_RESET%

REM Use PowerShell to detect and save all info directly (avoids batch parsing issues)
powershell -NoProfile -Command "$os = [System.Environment]::OSVersion.VersionString; $tz = (Get-TimeZone).Id; $comp = $env:COMPUTERNAME; $cpu = (Get-WmiObject -Class Win32_Processor).Name.Trim(); $ram = [math]::Round((Get-WmiObject -Class Win32_ComputerSystem).TotalPhysicalMemory / 1GB); @(\"SYS_OS=$os\", \"SYS_TIMEZONE=$tz\", \"SYS_COMPUTER=$comp\", \"SYS_CPU=$cpu\", \"SYS_RAM=${ram}GB\") | Out-File -FilePath '%~dp0config\system-info.txt' -Encoding ASCII"

echo %SUCCESS%System information saved!%C_RESET%
timeout /t 1 >nul
goto :eof

REM ============================================================
REM ABOUT DIALOG
REM ============================================================
:ShowAbout
cls
echo %HEADER%============================================================%C_RESET%
echo %HEADER%           ABOUT DUKE DESKTOP LAUNCHER%C_RESET%
echo %HEADER%============================================================%C_RESET%
echo.
echo %TEXT%Version:%C_RESET% %INFO%1.0%C_RESET%
echo %TEXT%Author:%C_RESET%  %INFO%Aaron%C_RESET%
echo %TEXT%GitHub:%C_RESET%  %INFO%github.com/yourusername/DukeDesktopLauncher%C_RESET%
echo.
echo %TEXT%A customizable desktop launcher inspired by Ghost Toolbox.%C_RESET%
echo %TEXT%Built with pure Windows Batch scripting and ANSI colors.%C_RESET%
echo.
echo %TEXT%Features: Browser quick links, Spotify, Weather, Quotes,%C_RESET%
echo %TEXT%System diagnostics, and more!%C_RESET%
echo.
echo %HEADER%============================================================%C_RESET%
echo.
pause
goto :eof

REM ============================================================
REM EXIT
REM ============================================================
:Exit
cls
echo.
echo %SUCCESS%Thank you for using Duke Desktop Launcher!%C_RESET%
echo.
timeout /t 2 /nobreak >nul
exit /b 0
REM ============================================================
REM PERSONALIZATION MENU
REM ============================================================
:PersonalizationMenu
cls
echo %HEADER%============================================================%C_RESET%
echo %HEADER%               PERSONALIZATION%C_RESET%
echo %HEADER%============================================================%C_RESET%
echo.
echo %TEXT%Select a color theme:%C_RESET%
echo.
echo %BRACKET%[1]%C_RESET% %C_BRIGHT_MAGENTA%Ghost Toolbox%C_RESET% %TEXT%(Purple ^& Cyan)%C_RESET%
echo %BRACKET%[2]%C_RESET% %C_BRIGHT_GREEN%Matrix%C_RESET% %TEXT%(Green ^& Black)%C_RESET%
echo %BRACKET%[3]%C_RESET% %C_BRIGHT_MAGENTA%Cyberpunk%C_RESET% %TEXT%(Magenta ^& Yellow)%C_RESET%
echo %BRACKET%[4]%C_RESET% %C_BRIGHT_BLUE%Ocean%C_RESET% %TEXT%(Blue ^& Cyan)%C_RESET%
echo %BRACKET%[5]%C_RESET% %C_BRIGHT_WHITE%Classic%C_RESET% %TEXT%(White ^& Gray)%C_RESET%
echo %BRACKET%[6]%C_RESET% %TEXT%Custom %TEXT%(Design Your Own)%C_RESET%
echo %BRACKET%[7]%C_RESET% %INFO%Reset to Defaults%C_RESET%
echo.
echo %BRACKET%[0]%C_RESET% %TEXT%Back to Menu%C_RESET%
echo %SEPARATOR%------------------------------------------------------------%C_RESET%
echo.
set /p "theme_choice=%TEXT%Type option:%C_RESET% "

if "%theme_choice%"=="0" goto :eof
if "%theme_choice%"=="1" call :ApplyTheme "Ghost Toolbox" "95m" "96m" "92m" "93m" "91m" "94m" "90m" "95m" & goto PersonalizationMenu
if "%theme_choice%"=="2" call :ApplyTheme "Matrix" "92m" "92m" "32m" "93m" "91m" "32m" "90m" "92m" & goto PersonalizationMenu
if "%theme_choice%"=="3" call :ApplyTheme "Cyberpunk" "95m" "97m" "93m" "93m" "91m" "95m" "90m" "95m" & goto PersonalizationMenu
if "%theme_choice%"=="4" call :ApplyTheme "Ocean" "94m" "97m" "96m" "93m" "91m" "94m" "90m" "96m" & goto PersonalizationMenu
if "%theme_choice%"=="5" call :ApplyTheme "Classic" "97m" "97m" "92m" "93m" "91m" "94m" "90m" "97m" & goto PersonalizationMenu
if "%theme_choice%"=="6" call :CustomTheme & goto PersonalizationMenu
if "%theme_choice%"=="7" call :ResetTheme & goto PersonalizationMenu

echo %ERROR%Invalid selection!%C_RESET%
timeout /t 1 >nul
goto PersonalizationMenu

REM ============================================================
REM APPLY THEME
REM ============================================================
:ApplyTheme
set "THEME_NAME=%~1"
set "H_COLOR=%~2"
set "T_COLOR=%~3"
set "S_COLOR=%~4"
set "W_COLOR=%~5"
set "E_COLOR=%~6"
set "I_COLOR=%~7"
set "B_COLOR=%~8"
set "SEP_COLOR=%~9"

REM Write to config file
(
echo # Duke Desktop Launcher - Color Scheme
echo # Theme: %THEME_NAME%
echo # ANSI Color Codes: 30-37 ^(normal^), 90-97 ^(bright^)
echo # Colors: Black=0, Red=1, Green=2, Yellow=3, Blue=4, Magenta=5, Cyan=6, White=7
echo.
echo HEADER_COLOR=%H_COLOR%
echo TEXT_COLOR=%T_COLOR%
echo SUCCESS_COLOR=%S_COLOR%
echo WARNING_COLOR=%W_COLOR%
echo ERROR_COLOR=%E_COLOR%
echo INFO_COLOR=%I_COLOR%
echo BRACKET_COLOR=%B_COLOR%
echo SEPARATOR_COLOR=%SEP_COLOR%
) > "%~dp0config\color-scheme.txt"

REM Reload colors
call modules\colors.cmd

echo.
echo %SUCCESS%Theme "%THEME_NAME%" applied successfully!%C_RESET%
timeout /t 2 >nul
goto :eof

REM ============================================================
REM CUSTOM THEME
REM ============================================================
:CustomTheme
cls
echo %HEADER%============================================================%C_RESET%
echo %HEADER%               CUSTOM THEME BUILDER%C_RESET%
echo %HEADER%============================================================%C_RESET%
echo.
echo %TEXT%ANSI Color Reference:%C_RESET%
echo.
echo %C_BLACK%[30m] Black%C_RESET%       %C_BRIGHT_BLACK%[90m] Bright Black%C_RESET%
echo %C_RED%[31m] Red%C_RESET%         %C_BRIGHT_RED%[91m] Bright Red%C_RESET%
echo %C_GREEN%[32m] Green%C_RESET%       %C_BRIGHT_GREEN%[92m] Bright Green%C_RESET%
echo %C_YELLOW%[33m] Yellow%C_RESET%      %C_BRIGHT_YELLOW%[93m] Bright Yellow%C_RESET%
echo %C_BLUE%[34m] Blue%C_RESET%        %C_BRIGHT_BLUE%[94m] Bright Blue%C_RESET%
echo %C_MAGENTA%[35m] Magenta%C_RESET%     %C_BRIGHT_MAGENTA%[95m] Bright Magenta%C_RESET%
echo %C_CYAN%[36m] Cyan%C_RESET%        %C_BRIGHT_CYAN%[96m] Bright Cyan%C_RESET%
echo %C_WHITE%[37m] White%C_RESET%       %C_BRIGHT_WHITE%[97m] Bright White%C_RESET%
echo.
echo %SEPARATOR%------------------------------------------------------------%C_RESET%
echo.

set /p "custom_header=%TEXT%Header Color (e.g., 96m):%C_RESET% "
set /p "custom_text=%TEXT%Text Color (e.g., 97m):%C_RESET% "
set /p "custom_success=%TEXT%Success Color (e.g., 92m):%C_RESET% "
set /p "custom_warning=%TEXT%Warning Color (e.g., 93m):%C_RESET% "
set /p "custom_error=%TEXT%Error Color (e.g., 91m):%C_RESET% "
set /p "custom_info=%TEXT%Info Color (e.g., 94m):%C_RESET% "
set /p "custom_bracket=%TEXT%Bracket Color (e.g., 90m):%C_RESET% "
set /p "custom_separator=%TEXT%Separator Color (e.g., 96m):%C_RESET% "

call :ApplyTheme "Custom" "%custom_header%" "%custom_text%" "%custom_success%" "%custom_warning%" "%custom_error%" "%custom_info%" "%custom_bracket%" "%custom_separator%"
goto :eof

REM APPLY THEME
REM ============================================================
:ApplyTheme
setlocal enabledelayedexpansion
set "THEME_NAME=%~1"
set "H_COL=%~2"
set "T_COL=%~3"
set "S_COL=%~4"
set "W_COL=%~5"
set "E_COL=%~6"
set "I_COL=%~7"
set "B_COL=%~8"
set "SEP_COL=%~9"

set "SCHEME_FILE=%~dp0config\color-scheme.txt"

(
echo # Duke Desktop Launcher - Color Scheme
echo # Theme: %THEME_NAME%
echo # ANSI Color Codes: 30-37 ^(normal^), 90-97 ^(bright^)
echo.
echo HEADER_COLOR=%H_COL%
echo TEXT_COLOR=%T_COL%
echo SUCCESS_COLOR=%S_COL%
echo WARNING_COLOR=%W_COL%
echo ERROR_COLOR=%E_COL%
echo INFO_COLOR=%I_COL%
echo BRACKET_COLOR=%B_COL%
echo SEPARATOR_COLOR=%SEP_COL%
) > "%SCHEME_FILE%"

REM Force reload colors immediately
endlocal
call "%~dp0modules\colors.cmd"

cls
echo %SUCCESS%Theme "%THEME_NAME%" applied successfully!%C_RESET%
echo %TEXT%Colors have been updated.%C_RESET%
timeout /t 2 >nul
goto :eof

REM ============================================================
REM CUSTOM THEME
REM ============================================================
:CustomTheme
cls
echo %HEADER%============================================================%C_RESET%
echo %HEADER%               CUSTOM THEME DESIGNER%C_RESET%
echo %HEADER%============================================================%C_RESET%
echo.
echo %TEXT%ANSI Color Reference:%C_RESET%
echo.
echo %C_BLACK%[30] Black%C_RESET%       %C_BRIGHT_BLACK%[90] Bright Black%C_RESET%
echo %C_RED%[31] Red%C_RESET%         %C_BRIGHT_RED%[91] Bright Red%C_RESET%
echo %C_GREEN%[32] Green%C_RESET%       %C_BRIGHT_GREEN%[92] Bright Green%C_RESET%
echo %C_YELLOW%[33] Yellow%C_RESET%      %C_BRIGHT_YELLOW%[93] Bright Yellow%C_RESET%
echo %C_BLUE%[34] Blue%C_RESET%        %C_BRIGHT_BLUE%[94] Bright Blue%C_RESET%
echo %C_MAGENTA%[35] Magenta%C_RESET%     %C_BRIGHT_MAGENTA%[95] Bright Magenta%C_RESET%
echo %C_CYAN%[36] Cyan%C_RESET%        %C_BRIGHT_CYAN%[96] Bright Cyan%C_RESET%
echo %C_WHITE%[37] White%C_RESET%       %C_BRIGHT_WHITE%[97] Bright White%C_RESET%
echo.
echo %SEPARATOR%------------------------------------------------------------%C_RESET%
echo.

set /p "H_CUSTOM=%TEXT%Header Color (e.g., 96m):%C_RESET% "
set /p "T_CUSTOM=%TEXT%Text Color (e.g., 97m):%C_RESET% "
set /p "S_CUSTOM=%TEXT%Success Color (e.g., 92m):%C_RESET% "
set /p "W_CUSTOM=%TEXT%Warning Color (e.g., 93m):%C_RESET% "
set /p "E_CUSTOM=%TEXT%Error Color (e.g., 91m):%C_RESET% "
set /p "I_CUSTOM=%TEXT%Info Color (e.g., 94m):%C_RESET% "
set /p "B_CUSTOM=%TEXT%Bracket Color (e.g., 90m):%C_RESET% "
set /p "SEP_CUSTOM=%TEXT%Separator Color (e.g., 96m):%C_RESET% "

call :ApplyTheme "Custom" "%H_CUSTOM%" "%T_CUSTOM%" "%S_CUSTOM%" "%W_CUSTOM%" "%E_CUSTOM%" "%I_CUSTOM%" "%B_CUSTOM%" "%SEP_CUSTOM%"
goto :eof

REM ============================================================
REM RESET THEME TO DEFAULTS
REM ============================================================
:ResetTheme
call :ApplyTheme "Default" "96m" "97m" "92m" "93m" "91m" "94m" "90m" "96m"

REM Force reload colors by calling colors.cmd again
call "%~dp0modules\colors.cmd"

cls
echo %SUCCESS%Theme reset to defaults successfully!%C_RESET%
echo %TEXT%Colors have been updated.%C_RESET%
timeout /t 2 >nul
goto :eof

REM ============================================================
REM VALIDATE URL
REM ============================================================
:ValidateURL
setlocal
set "URL=%~1"

REM Check if URL starts with http:// or https://
echo %URL% | findstr /i /b "http:// https://" >nul 2>&1
if errorlevel 1 exit /b 1

REM Check for dangerous characters
echo %URL% | findstr /r "[&\|><\^;`$()!]" >nul 2>&1
if not errorlevel 1 exit /b 1

exit /b 0

REM ============================================================
REM SANITIZE LINK NAME
REM ============================================================
:SanitizeLinkName
setlocal enabledelayedexpansion
set "VAR_NAME=%~1"
set "INPUT=!%VAR_NAME%!"

REM Remove dangerous characters
set "INPUT=%INPUT:&=%"
set "INPUT=%INPUT:|=%"
set "INPUT=%INPUT:>=%"
set "INPUT=%INPUT:<=%"
set "INPUT=%INPUT:^=%"
set "INPUT=%INPUT:;=%"
set "INPUT=%INPUT:`=%"
set "INPUT=%INPUT:$=%"
set "INPUT=%INPUT:(=%"
set "INPUT=%INPUT:)=%"
set "INPUT=%INPUT:!=%"
set "INPUT=%INPUT:@=%"
set "INPUT=%INPUT:#=%"
set "INPUT=%INPUT:%%=%"

endlocal & set "%VAR_NAME%=%INPUT%"
goto :eof

REM ============================================================
REM SANITIZE SEARCH QUERY
REM ============================================================
:SanitizeSearchQuery
setlocal enabledelayedexpansion
set "VAR_NAME=%~1"
set "INPUT=!%VAR_NAME%!"

REM Remove dangerous characters for URL encoding
set "INPUT=%INPUT:&=%"
set "INPUT=%INPUT:|=%"
set "INPUT=%INPUT:>=%"
set "INPUT=%INPUT:<=%"
set "INPUT=%INPUT:^=%"
set "INPUT=%INPUT:;=%"
set "INPUT=%INPUT:`=%"
set "INPUT=%INPUT:$=%"
set "INPUT=%INPUT:(=%"
set "INPUT=%INPUT:)=%"
set "INPUT=%INPUT:!=%"
set "INPUT=%INPUT:"=%"
set "INPUT=%INPUT:'=%"

endlocal & set "%VAR_NAME%=%INPUT%"
goto :eof

REM ============================================================

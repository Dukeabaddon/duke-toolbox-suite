@echo off
setlocal enabledelayedexpansion

:: Duke Desktop Launcher - Enhanced Browser Detection Module
:: Detects 20+ browsers with Windows executable paths
:: Only shows detected browsers

REM ============================================================
REM BROWSER DETECTION PATHS
REM ============================================================

REM Tier 1: Common Browsers
set "BRAVE_PATH_1=%LOCALAPPDATA%\BraveSoftware\Brave-Browser\Application\brave.exe"
set "BRAVE_PATH_2=%PROGRAMFILES%\BraveSoftware\Brave-Browser\Application\brave.exe"
set "BRAVE_PATH_3=%PROGRAMFILES(x86)%\BraveSoftware\Brave-Browser\Application\brave.exe"

set "CHROME_PATH_1=%LOCALAPPDATA%\Google\Chrome\Application\chrome.exe"
set "CHROME_PATH_2=%PROGRAMFILES%\Google\Chrome\Application\chrome.exe"
set "CHROME_PATH_3=%PROGRAMFILES(x86)%\Google\Chrome\Application\chrome.exe"

set "EDGE_PATH_1=%PROGRAMFILES(x86)%\Microsoft\Edge\Application\msedge.exe"
set "EDGE_PATH_2=%PROGRAMFILES%\Microsoft\Edge\Application\msedge.exe"

set "FIREFOX_PATH_1=%PROGRAMFILES%\Mozilla Firefox\firefox.exe"
set "FIREFOX_PATH_2=%PROGRAMFILES(x86)%\Mozilla Firefox\firefox.exe"

set "OPERA_PATH_1=%LOCALAPPDATA%\Programs\Opera\opera.exe"
set "OPERA_PATH_2=%PROGRAMFILES%\Opera\opera.exe"
set "OPERA_PATH_3=%PROGRAMFILES(x86)%\Opera\opera.exe"

set "VIVALDI_PATH_1=%LOCALAPPDATA%\Vivaldi\Application\vivaldi.exe"
set "VIVALDI_PATH_2=%PROGRAMFILES%\Vivaldi\Application\vivaldi.exe"

set "ARC_PATH_1=%LOCALAPPDATA%\Arc\Application\Arc.exe"

set "SIDEKICK_PATH_1=%LOCALAPPDATA%\Sidekick\Application\sidekick.exe"

REM Tier 2: Privacy Browsers
set "TOR_PATH_1=%LOCALAPPDATA%\Tor Browser\Browser\firefox.exe"
set "TOR_PATH_2=%USERPROFILE%\Desktop\Tor Browser\Browser\firefox.exe"

set "WATERFOX_PATH_1=%PROGRAMFILES%\Waterfox\waterfox.exe"
set "WATERFOX_PATH_2=%PROGRAMFILES(x86)%\Waterfox\waterfox.exe"

set "LIBREWOLF_PATH_1=%PROGRAMFILES%\LibreWolf\librewolf.exe"

set "PALEMOON_PATH_1=%PROGRAMFILES%\Pale Moon\palemoon.exe"
set "PALEMOON_PATH_2=%PROGRAMFILES(x86)%\Pale Moon\palemoon.exe"

REM Tier 3: Gaming
set "OPERAGX_PATH_1=%LOCALAPPDATA%\Programs\Opera GX\opera.exe"
set "OPERAGX_PATH_2=%PROGRAMFILES%\Opera GX\opera.exe"

REM Tier 4: Developer
set "CHROME_CANARY_PATH_1=%LOCALAPPDATA%\Google\Chrome SxS\Application\chrome.exe"

set "FIREFOX_DEV_PATH_1=%PROGRAMFILES%\Firefox Developer Edition\firefox.exe"
set "FIREFOX_DEV_PATH_2=%PROGRAMFILES(x86)%\Firefox Developer Edition\firefox.exe"

set "EDGE_DEV_PATH_1=%PROGRAMFILES(x86)%\Microsoft\Edge Dev\Application\msedge.exe"
set "EDGE_DEV_PATH_2=%PROGRAMFILES%\Microsoft\Edge Dev\Application\msedge.exe"

REM Tier 5: Legacy
set "IE_PATH_1=%PROGRAMFILES%\Internet Explorer\iexplore.exe"
set "IE_PATH_2=%PROGRAMFILES(x86)%\Internet Explorer\iexplore.exe"

REM ============================================================
REM DETECTION LOGIC
REM ============================================================

REM Detect Brave
if exist "%BRAVE_PATH_1%" (
    set "BRAVE_PATH=%BRAVE_PATH_1%"
    set "BRAVE_DETECTED=1"
) else if exist "%BRAVE_PATH_2%" (
    set "BRAVE_PATH=%BRAVE_PATH_2%"
    set "BRAVE_DETECTED=1"
) else if exist "%BRAVE_PATH_3%" (
    set "BRAVE_PATH=%BRAVE_PATH_3%"
    set "BRAVE_DETECTED=1"
) else (
    set "BRAVE_DETECTED=0"
)

REM Detect Chrome
if exist "%CHROME_PATH_1%" (
    set "CHROME_PATH=%CHROME_PATH_1%"
    set "CHROME_DETECTED=1"
) else if exist "%CHROME_PATH_2%" (
    set "CHROME_PATH=%CHROME_PATH_2%"
    set "CHROME_DETECTED=1"
) else if exist "%CHROME_PATH_3%" (
    set "CHROME_PATH=%CHROME_PATH_3%"
    set "CHROME_DETECTED=1"
) else (
    set "CHROME_DETECTED=0"
)

REM Detect Edge
if exist "%EDGE_PATH_1%" (
    set "EDGE_PATH=%EDGE_PATH_1%"
    set "EDGE_DETECTED=1"
) else if exist "%EDGE_PATH_2%" (
    set "EDGE_PATH=%EDGE_PATH_2%"
    set "EDGE_DETECTED=1"
) else (
    set "EDGE_DETECTED=0"
)

REM Detect Firefox
if exist "%FIREFOX_PATH_1%" (
    set "FIREFOX_PATH=%FIREFOX_PATH_1%"
    set "FIREFOX_DETECTED=1"
) else if exist "%FIREFOX_PATH_2%" (
    set "FIREFOX_PATH=%FIREFOX_PATH_2%"
    set "FIREFOX_DETECTED=1"
) else (
    set "FIREFOX_DETECTED=0"
)

REM Detect Opera
if exist "%OPERA_PATH_1%" (
    set "OPERA_PATH=%OPERA_PATH_1%"
    set "OPERA_DETECTED=1"
) else if exist "%OPERA_PATH_2%" (
    set "OPERA_PATH=%OPERA_PATH_2%"
    set "OPERA_DETECTED=1"
) else if exist "%OPERA_PATH_3%" (
    set "OPERA_PATH=%OPERA_PATH_3%"
    set "OPERA_DETECTED=1"
) else (
    set "OPERA_DETECTED=0"
)

REM Detect Vivaldi
if exist "%VIVALDI_PATH_1%" (
    set "VIVALDI_PATH=%VIVALDI_PATH_1%"
    set "VIVALDI_DETECTED=1"
) else if exist "%VIVALDI_PATH_2%" (
    set "VIVALDI_PATH=%VIVALDI_PATH_2%"
    set "VIVALDI_DETECTED=1"
) else (
    set "VIVALDI_DETECTED=0"
)

REM Detect Arc
if exist "%ARC_PATH_1%" (
    set "ARC_PATH=%ARC_PATH_1%"
    set "ARC_DETECTED=1"
) else (
    set "ARC_DETECTED=0"
)

REM Detect Sidekick
if exist "%SIDEKICK_PATH_1%" (
    set "SIDEKICK_PATH=%SIDEKICK_PATH_1%"
    set "SIDEKICK_DETECTED=1"
) else (
    set "SIDEKICK_DETECTED=0"
)

REM Detect Tor Browser
if exist "%TOR_PATH_1%" (
    set "TOR_PATH=%TOR_PATH_1%"
    set "TOR_DETECTED=1"
) else if exist "%TOR_PATH_2%" (
    set "TOR_PATH=%TOR_PATH_2%"
    set "TOR_DETECTED=1"
) else (
    set "TOR_DETECTED=0"
)

REM Detect Waterfox
if exist "%WATERFOX_PATH_1%" (
    set "WATERFOX_PATH=%WATERFOX_PATH_1%"
    set "WATERFOX_DETECTED=1"
) else if exist "%WATERFOX_PATH_2%" (
    set "WATERFOX_PATH=%WATERFOX_PATH_2%"
    set "WATERFOX_DETECTED=1"
) else (
    set "WATERFOX_DETECTED=0"
)

REM Detect LibreWolf
if exist "%LIBREWOLF_PATH_1%" (
    set "LIBREWOLF_PATH=%LIBREWOLF_PATH_1%"
    set "LIBREWOLF_DETECTED=1"
) else (
    set "LIBREWOLF_DETECTED=0"
)

REM Detect Pale Moon
if exist "%PALEMOON_PATH_1%" (
    set "PALEMOON_PATH=%PALEMOON_PATH_1%"
    set "PALEMOON_DETECTED=1"
) else if exist "%PALEMOON_PATH_2%" (
    set "PALEMOON_PATH=%PALEMOON_PATH_2%"
    set "PALEMOON_DETECTED=1"
) else (
    set "PALEMOON_DETECTED=0"
)

REM Detect Opera GX
if exist "%OPERAGX_PATH_1%" (
    set "OPERAGX_PATH=%OPERAGX_PATH_1%"
    set "OPERAGX_DETECTED=1"
) else if exist "%OPERAGX_PATH_2%" (
    set "OPERAGX_PATH=%OPERAGX_PATH_2%"
    set "OPERAGX_DETECTED=1"
) else (
    set "OPERAGX_DETECTED=0"
)

REM Detect Chrome Canary
if exist "%CHROME_CANARY_PATH_1%" (
    set "CHROME_CANARY_PATH=%CHROME_CANARY_PATH_1%"
    set "CHROME_CANARY_DETECTED=1"
) else (
    set "CHROME_CANARY_DETECTED=0"
)

REM Detect Firefox Developer Edition
if exist "%FIREFOX_DEV_PATH_1%" (
    set "FIREFOX_DEV_PATH=%FIREFOX_DEV_PATH_1%"
    set "FIREFOX_DEV_DETECTED=1"
) else if exist "%FIREFOX_DEV_PATH_2%" (
    set "FIREFOX_DEV_PATH=%FIREFOX_DEV_PATH_2%"
    set "FIREFOX_DEV_DETECTED=1"
) else (
    set "FIREFOX_DEV_DETECTED=0"
)

REM Detect Edge Dev
if exist "%EDGE_DEV_PATH_1%" (
    set "EDGE_DEV_PATH=%EDGE_DEV_PATH_1%"
    set "EDGE_DEV_DETECTED=1"
) else if exist "%EDGE_DEV_PATH_2%" (
    set "EDGE_DEV_PATH=%EDGE_DEV_PATH_2%"
    set "EDGE_DEV_DETECTED=1"
) else (
    set "EDGE_DEV_DETECTED=0"
)

REM Detect Internet Explorer
if exist "%IE_PATH_1%" (
    set "IE_PATH=%IE_PATH_1%"
    set "IE_DETECTED=1"
) else if exist "%IE_PATH_2%" (
    set "IE_PATH=%IE_PATH_2%"
    set "IE_DETECTED=1"
) else (
    set "IE_DETECTED=0"
)

REM ============================================================
REM SAVE TO CONFIG
REM ============================================================

(
    echo REM Detected browsers - Auto-generated
    if !BRAVE_DETECTED! equ 1 echo BRAVE_PATH=!BRAVE_PATH!
    if !CHROME_DETECTED! equ 1 echo CHROME_PATH=!CHROME_PATH!
    if !EDGE_DETECTED! equ 1 echo EDGE_PATH=!EDGE_PATH!
    if !FIREFOX_DETECTED! equ 1 echo FIREFOX_PATH=!FIREFOX_PATH!
    if !OPERA_DETECTED! equ 1 echo OPERA_PATH=!OPERA_PATH!
    if !VIVALDI_DETECTED! equ 1 echo VIVALDI_PATH=!VIVALDI_PATH!
    if !ARC_DETECTED! equ 1 echo ARC_PATH=!ARC_PATH!
    if !SIDEKICK_DETECTED! equ 1 echo SIDEKICK_PATH=!SIDEKICK_PATH!
    if !TOR_DETECTED! equ 1 echo TOR_PATH=!TOR_PATH!
    if !WATERFOX_DETECTED! equ 1 echo WATERFOX_PATH=!WATERFOX_PATH!
    if !LIBREWOLF_DETECTED! equ 1 echo LIBREWOLF_PATH=!LIBREWOLF_PATH!
    if !PALEMOON_DETECTED! equ 1 echo PALEMOON_PATH=!PALEMOON_PATH!
    if !OPERAGX_DETECTED! equ 1 echo OPERAGX_PATH=!OPERAGX_PATH!
    if !CHROME_CANARY_DETECTED! equ 1 echo CHROME_CANARY_PATH=!CHROME_CANARY_PATH!
    if !FIREFOX_DEV_DETECTED! equ 1 echo FIREFOX_DEV_PATH=!FIREFOX_DEV_PATH!
    if !EDGE_DEV_DETECTED! equ 1 echo EDGE_DEV_PATH=!EDGE_DEV_PATH!
    if !IE_DETECTED! equ 1 echo IE_PATH=!IE_PATH!
    echo.
    echo REM Detection flags
    echo BRAVE_DETECTED=!BRAVE_DETECTED!
    echo CHROME_DETECTED=!CHROME_DETECTED!
    echo EDGE_DETECTED=!EDGE_DETECTED!
    echo FIREFOX_DETECTED=!FIREFOX_DETECTED!
    echo OPERA_DETECTED=!OPERA_DETECTED!
    echo VIVALDI_DETECTED=!VIVALDI_DETECTED!
    echo ARC_DETECTED=!ARC_DETECTED!
    echo SIDEKICK_DETECTED=!SIDEKICK_DETECTED!
    echo TOR_DETECTED=!TOR_DETECTED!
    echo WATERFOX_DETECTED=!WATERFOX_DETECTED!
    echo LIBREWOLF_DETECTED=!LIBREWOLF_DETECTED!
    echo PALEMOON_DETECTED=!PALEMOON_DETECTED!
    echo OPERAGX_DETECTED=!OPERAGX_DETECTED!
    echo CHROME_CANARY_DETECTED=!CHROME_CANARY_DETECTED!
    echo FIREFOX_DEV_DETECTED=!FIREFOX_DEV_DETECTED!
    echo EDGE_DEV_DETECTED=!EDGE_DEV_DETECTED!
    echo IE_DETECTED=!IE_DETECTED!
) > "%~dp0..\config\detected-browsers.txt"

exit /b 0

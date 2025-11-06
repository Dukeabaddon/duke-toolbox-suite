@echo off
setlocal enabledelayedexpansion

:: Duke Desktop Launcher - Spotify Integration
:: Launch Spotify and search for music

call "%~dp0colors.cmd"

:SpotifyMenu
cls
echo.
echo %HEADER%%SEPARATOR%%RESET%
echo %HEADER%               SPOTIFY%RESET%
echo %HEADER%%SEPARATOR%%RESET%
echo.

echo %BRACKET%[%RESET%%TEXT%1%RESET%%BRACKET%]%RESET% %TEXT%Launch Spotify%RESET%
echo %BRACKET%[%RESET%%TEXT%2%RESET%%BRACKET%]%RESET% %TEXT%Search Spotify%RESET%
echo %BRACKET%[%RESET%%TEXT%3%RESET%%BRACKET%]%RESET% %TEXT%Open Spotify Web Player%RESET%
echo.
echo %BRACKET%[%RESET%%TEXT%0%RESET%%BRACKET%]%RESET% %TEXT%Back to Main Menu%RESET%
echo.
echo %HEADER%%SEPARATOR%%RESET%
echo.

set /p "CHOICE=%BRACKET%[%RESET%%TEXT%?%RESET%%BRACKET%]%RESET% %TEXT%Select option: %RESET%"

if "%CHOICE%"=="0" exit /b 0
if "%CHOICE%"=="1" goto LaunchSpotify
if "%CHOICE%"=="2" goto SearchSpotify
if "%CHOICE%"=="3" goto WebPlayer

echo %ERROR%Invalid selection!%RESET%
timeout /t 2 >nul
goto SpotifyMenu

:LaunchSpotify
echo.
echo %TEXT%Launching Spotify...%RESET%

:: Try spotify: URI first (desktop app)
start "" spotify: >nul 2>&1

if errorlevel 1 (
    :: Fallback to direct exe launch
    if exist "%AppData%\Spotify\Spotify.exe" (
        start "" "%AppData%\Spotify\Spotify.exe"
    ) else (
        echo %ERROR%Spotify desktop app not found!%RESET%
        echo %TEXT%Opening Spotify Web Player instead...%RESET%
        start "" "https://open.spotify.com"
    )
)

timeout /t 2 >nul
goto SpotifyMenu

:SearchSpotify
cls
echo.
echo %HEADER%%SEPARATOR%%RESET%
echo %HEADER%            SPOTIFY SEARCH%RESET%
echo %HEADER%%SEPARATOR%%RESET%
echo.

set /p "QUERY=%BRACKET%[%RESET%%TEXT%?%RESET%%BRACKET%]%RESET% %TEXT%Search for (song, artist, album): %RESET%"

if "%QUERY%"=="" (
    echo %ERROR%Search query cannot be empty!%RESET%
    timeout /t 2 >nul
    goto SpotifyMenu
)

:: URL encode the search query (basic encoding)
set "ENCODED_QUERY=!QUERY: =+!"
set "ENCODED_QUERY=!ENCODED_QUERY:'=%%27!"
set "ENCODED_QUERY=!ENCODED_QUERY:"=%%22!"

echo.
echo %TEXT%Searching for: "%QUERY%"%RESET%

:: Try spotify:search: URI scheme (desktop app)
start "" "spotify:search:!ENCODED_QUERY!" >nul 2>&1

:: Check if it failed (app not installed)
if errorlevel 1 (
    echo %WARNING%Spotify app not detected. Opening web search...%RESET%
    start "" "https://open.spotify.com/search/!ENCODED_QUERY!"
)

timeout /t 2 >nul
goto SpotifyMenu

:WebPlayer
echo.
echo %TEXT%Opening Spotify Web Player...%RESET%
start "" "https://open.spotify.com"
timeout /t 2 >nul
goto SpotifyMenu

@echo off
setlocal enabledelayedexpansion

call "%~dp0colors.cmd"

cls
echo %HEADER%============================================================%C_RESET%
echo %HEADER%                INSPIRATIONAL QUOTE%C_RESET%
echo %HEADER%============================================================%C_RESET%
echo.

set "FALLBACK[0]=The only way to do great work is to love what you do. - Steve Jobs"
set "FALLBACK[1]=Success is not final, failure is not fatal. - Winston Churchill"
set "FALLBACK[2]=Believe you can and you're halfway there. - Theodore Roosevelt"
set "FALLBACK[3]=The future belongs to those who believe in the beauty of their dreams. - Eleanor Roosevelt"
set "FALLBACK[4]=It does not matter how slowly you go as long as you do not stop. - Confucius"
set "FALLBACK[5]=Everything you've ever wanted is on the other side of fear. - George Addair"

echo %TEXT%Fetching inspirational quote...%C_RESET%
echo.

set "API_URL=https://zenquotes.io/api/random"
set "TEMP_FILE=%TEMP%\duke-quote.json"

curl -s --max-time 5 "%API_URL%" > "%TEMP_FILE%" 2>nul

if errorlevel 1 (
    echo %WARNING%API unavailable - using offline quote.%C_RESET%
    goto :FallbackQuote
)

powershell -NoProfile -Command "$ErrorActionPreference='Stop'; try { $json = Get-Content '%TEMP_FILE%' -Raw | ConvertFrom-Json; Write-Host $json[0].q'|'$json[0].a } catch { exit 1 }" >nul 2>&1

if errorlevel 1 (
    echo %WARNING%Invalid response - using offline quote.%C_RESET%
    goto :FallbackQuote
)

for /f "delims=" %%a in ('powershell -NoProfile -Command "$json = Get-Content '%TEMP_FILE%' -Raw | ConvertFrom-Json; Write-Host $json[0].q'|'$json[0].a"') do set "QUOTE_DATA=%%a"

for /f "tokens=1,* delims=|" %%a in ("%QUOTE_DATA%") do (
    set "QUOTE_TEXT=%%a"
    set "QUOTE_AUTHOR=%%b"
)

if not defined QUOTE_TEXT goto :FallbackQuote
if not defined QUOTE_AUTHOR set "QUOTE_AUTHOR=Unknown"

echo %SEPARATOR%------------------------------------------------------------%C_RESET%
echo.
echo %SUCCESS%   "%QUOTE_TEXT%"%C_RESET%
echo.
echo %TEXT%   - %QUOTE_AUTHOR%%C_RESET%
echo.
echo %SEPARATOR%------------------------------------------------------------%C_RESET%
echo.
echo %TEXT%Source:%C_RESET% %BRACKET%zenquotes.io%C_RESET%
echo.

del "%TEMP_FILE%" 2>nul

echo %BRACKET%[0]%C_RESET% %TEXT%Back to Menu%C_RESET%
echo.
choice /c 0 /n /m ""
exit /b 0

:FallbackQuote
set /a "RAND_INDEX=%RANDOM% %% 6"
set "SELECTED_QUOTE=!FALLBACK[%RAND_INDEX%]!"

for /f "tokens=1,* delims=-" %%a in ("!SELECTED_QUOTE!") do (
    set "QUOTE_TEXT=%%a"
    set "QUOTE_AUTHOR=%%b"
)

echo %SEPARATOR%------------------------------------------------------------%C_RESET%
echo.
echo %SUCCESS%   "%QUOTE_TEXT%"%C_RESET%
echo.
echo %TEXT%   -%QUOTE_AUTHOR%%C_RESET%
echo.
echo %SEPARATOR%------------------------------------------------------------%C_RESET%
echo.
echo %TEXT%Source:%C_RESET% %BRACKET%Offline fallback%C_RESET%
echo.

del "%TEMP_FILE%" 2>nul

echo %BRACKET%[0]%C_RESET% %TEXT%Back to Menu%C_RESET%
echo.
choice /c 0 /n /m ""
exit /b 0

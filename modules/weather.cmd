@echo off
setlocal enabledelayedexpansion

call "%~dp0colors.cmd"

:ShowWeather
cls
echo %HEADER%============================================================%C_RESET%
echo %HEADER%                   WEATHER DISPLAY%C_RESET%
echo %HEADER%============================================================%C_RESET%
echo.

echo %TEXT%Detecting location...%C_RESET%
echo.

set "TEMP_FILE=%TEMP%\duke-location.json"
curl -s --max-time 10 "http://ip-api.com/json/?fields=city,lat,lon,country" > "%TEMP_FILE%" 2>nul

if errorlevel 1 (
    echo %ERROR%Failed to detect location!%C_RESET%
    echo %TEXT%Check your internet connection.%C_RESET%
    echo.
    echo %BRACKET%[%RESET%%TEXT%0%RESET%%BRACKET%]%RESET% %TEXT%Back to Main Menu%RESET%
    echo.
    choice /c 0 /n /m ""
    exit /b 0
)

for /f "delims=" %%a in ('powershell -NoProfile -Command "$json = Get-Content '%TEMP_FILE%' -Raw | ConvertFrom-Json; Write-Host $json.city'|'$json.lat'|'$json.lon'|'$json.country"') do set "LOCATION_DATA=%%a"

for /f "tokens=1-4 delims=|" %%a in ("%LOCATION_DATA%") do (
    set "CITY=%%a"
    set "LAT=%%b"
    set "LON=%%c"
    set "COUNTRY=%%d"
)

if not defined LAT (
    echo %ERROR%Failed to parse location data!%C_RESET%
    del "%TEMP_FILE%" 2>nul
    echo.
    echo %BRACKET%[%RESET%%TEXT%0%RESET%%BRACKET%]%RESET% %TEXT%Back to Main Menu%RESET%
    echo.
    choice /c 0 /n /m ""
    exit /b 0
)

echo %TEXT%Location:%C_RESET% %SUCCESS%!CITY!, !COUNTRY!%C_RESET%
echo %TEXT%Coordinates:%C_RESET% %SUCCESS%!LAT!, !LON!%C_RESET%
echo %TEXT%Note:%C_RESET% %INFO%IP-based location (approximate within 50km)%C_RESET%
echo.
echo %TEXT%Fetching weather data...%C_RESET%
echo.

set "WEATHER_URL=https://api.open-meteo.com/v1/forecast?latitude=!LAT!&longitude=!LON!&current=temperature_2m,relative_humidity_2m,weather_code,wind_speed_10m"
set "WEATHER_FILE=%TEMP%\duke-weather.json"

curl -s --max-time 10 "%WEATHER_URL%" > "%WEATHER_FILE%" 2>nul

if errorlevel 1 (
    echo %ERROR%Failed to fetch weather data!%C_RESET%
    echo %TEXT%Open-Meteo API may be unavailable.%C_RESET%
    del "%TEMP_FILE%" "%WEATHER_FILE%" 2>nul
    echo.
    echo %BRACKET%[%RESET%%TEXT%0%RESET%%BRACKET%]%RESET% %TEXT%Back to Main Menu%RESET%
    echo.
    choice /c 0 /n /m ""
    exit /b 0
)

for /f "delims=" %%a in ('powershell -NoProfile -Command "$json = Get-Content '%WEATHER_FILE%' -Raw | ConvertFrom-Json; $c = $json.current; Write-Host $c.temperature_2m'|'$c.relative_humidity_2m'|'$c.weather_code'|'$c.wind_speed_10m"') do set "WEATHER_DATA=%%a"

for /f "tokens=1-4 delims=|" %%a in ("%WEATHER_DATA%") do (
    set "TEMP=%%a"
    set "HUMIDITY=%%b"
    set "CODE=%%c"
    set "WIND=%%d"
)

if not defined TEMP (
    echo %ERROR%Failed to parse weather data!%C_RESET%
    del "%TEMP_FILE%" "%WEATHER_FILE%" 2>nul
    echo.
    echo %BRACKET%[%RESET%%TEXT%0%RESET%%BRACKET%]%RESET% %TEXT%Back to Main Menu%RESET%
    echo.
    choice /c 0 /n /m ""
    exit /b 0
)

call :WeatherDescription !CODE!

echo %HEADER%-------------------------------------------------------------%C_RESET%
echo %TEXT%  Temperature:%C_RESET%   %SUCCESS%!TEMP!C%C_RESET%
echo %TEXT%  Humidity:%C_RESET%      %SUCCESS%!HUMIDITY!%%%C_RESET%
echo %TEXT%  Conditions:%C_RESET%    %SUCCESS%!WEATHER_DESC!%C_RESET%
echo %TEXT%  Wind Speed:%C_RESET%    %SUCCESS%!WIND! km/h%C_RESET%
echo %HEADER%-------------------------------------------------------------%C_RESET%
echo.

del "%TEMP_FILE%" "%WEATHER_FILE%" 2>nul

echo %BRACKET%[%RESET%%TEXT%0%RESET%%BRACKET%]%RESET% %TEXT%Back to Main Menu%RESET%
echo.
choice /c 0 /n /m ""
exit /b 0

:WeatherDescription
set "WMO_CODE=%1"
set "WEATHER_DESC=Unknown"

if "%WMO_CODE%"=="0" set "WEATHER_DESC=Clear sky"
if "%WMO_CODE%"=="1" set "WEATHER_DESC=Mainly clear"
if "%WMO_CODE%"=="2" set "WEATHER_DESC=Partly cloudy"
if "%WMO_CODE%"=="3" set "WEATHER_DESC=Overcast"
if "%WMO_CODE%"=="45" set "WEATHER_DESC=Foggy"
if "%WMO_CODE%"=="48" set "WEATHER_DESC=Depositing rime fog"
if "%WMO_CODE%"=="51" set "WEATHER_DESC=Light drizzle"
if "%WMO_CODE%"=="53" set "WEATHER_DESC=Moderate drizzle"
if "%WMO_CODE%"=="55" set "WEATHER_DESC=Dense drizzle"
if "%WMO_CODE%"=="61" set "WEATHER_DESC=Slight rain"
if "%WMO_CODE%"=="63" set "WEATHER_DESC=Moderate rain"
if "%WMO_CODE%"=="65" set "WEATHER_DESC=Heavy rain"
if "%WMO_CODE%"=="71" set "WEATHER_DESC=Slight snow"
if "%WMO_CODE%"=="73" set "WEATHER_DESC=Moderate snow"
if "%WMO_CODE%"=="75" set "WEATHER_DESC=Heavy snow"
if "%WMO_CODE%"=="77" set "WEATHER_DESC=Snow grains"
if "%WMO_CODE%"=="80" set "WEATHER_DESC=Slight rain showers"
if "%WMO_CODE%"=="81" set "WEATHER_DESC=Moderate rain showers"
if "%WMO_CODE%"=="82" set "WEATHER_DESC=Violent rain showers"
if "%WMO_CODE%"=="85" set "WEATHER_DESC=Slight snow showers"
if "%WMO_CODE%"=="86" set "WEATHER_DESC=Heavy snow showers"
if "%WMO_CODE%"=="95" set "WEATHER_DESC=Thunderstorm"
if "%WMO_CODE%"=="96" set "WEATHER_DESC=Thunderstorm with slight hail"
if "%WMO_CODE%"=="99" set "WEATHER_DESC=Thunderstorm with heavy hail"

exit /b

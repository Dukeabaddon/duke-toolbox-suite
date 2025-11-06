@echo off
setlocal enabledelayedexpansion

:: Duke Desktop Launcher - Disk Space Analyzer
:: Analyze drive usage and find largest folders

call "%~dp0colors.cmd"

:DiskMenu
cls
echo.
echo %HEADER%%SEPARATOR%%RESET%
echo %HEADER%         DISK SPACE ANALYZER%RESET%
echo %HEADER%%SEPARATOR%%RESET%
echo.

echo %BRACKET%[%RESET%%TEXT%1%RESET%%BRACKET%]%RESET% %TEXT%Show All Drives%RESET%
echo %BRACKET%[%RESET%%TEXT%2%RESET%%BRACKET%]%RESET% %TEXT%Analyze Specific Drive%RESET%
echo %BRACKET%[%RESET%%TEXT%3%RESET%%BRACKET%]%RESET% %TEXT%Find Largest Folders%RESET%
echo %BRACKET%[%RESET%%TEXT%4%RESET%%BRACKET%]%RESET% %TEXT%Quick Disk Cleanup%RESET%
echo %BRACKET%[%RESET%%TEXT%5%RESET%%BRACKET%]%RESET% %TEXT%Folder Size Calculator%RESET%
echo.
echo %BRACKET%[%RESET%%TEXT%0%RESET%%BRACKET%]%RESET% %TEXT%Back to Main Menu%RESET%
echo.
echo %HEADER%%SEPARATOR%%RESET%
echo.

set /p "CHOICE=%TEXT%Type option:%RESET% "

if "%CHOICE%"=="0" exit /b 0
if "%CHOICE%"=="1" goto ShowDrives
if "%CHOICE%"=="2" goto AnalyzeDrive
if "%CHOICE%"=="3" goto FindLargest
if "%CHOICE%"=="4" goto DiskCleanup
if "%CHOICE%"=="5" goto FolderSize

echo %ERROR%Invalid selection!%RESET%
timeout /t 2 >nul
goto DiskMenu

:ShowDrives
cls
echo.
echo %HEADER%%SEPARATOR%%RESET%
echo %HEADER%            ALL DRIVES%RESET%
echo %HEADER%%SEPARATOR%%RESET%
echo.

echo %TEXT%Scanning drives...%RESET%
echo.

REM Use PowerShell to get drive info with colored progress bars
powershell -NoProfile -Command "Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Used -ne $null } | ForEach-Object { $name = $_.Name; $used = [math]::Round($_.Used / 1GB, 2); $free = [math]::Round($_.Free / 1GB, 2); $total = $used + $free; if ($total -gt 0) { $percent = [math]::Round(($used / $total) * 100, 1) } else { $percent = 0 }; $bar = ''; $filled = [math]::Floor($percent / 5); for ($i = 0; $i -lt 20; $i++) { if ($i -lt $filled) { $bar += '█' } else { $bar += '░' } }; Write-Host \"${name}: [$bar] ${percent}%%\" -ForegroundColor Cyan; Write-Host \"    Used: ${used} GB | Free: ${free} GB | Total: ${total} GB\" -ForegroundColor White; Write-Host '' }"

echo.
echo %HEADER%%SEPARATOR%%RESET%
echo.
echo %BRACKET%[%RESET%%TEXT%0%RESET%%BRACKET%]%RESET% %TEXT%Back to Disk Menu%RESET%
echo.
choice /c 0 /n /m ""
goto DiskMenu

:AnalyzeDrive
cls
echo.
echo %HEADER%%SEPARATOR%%RESET%
echo %HEADER%          ANALYZE DRIVE%RESET%
echo %HEADER%%SEPARATOR%%RESET%
echo.

set /p "DRIVE=%TEXT%Enter drive letter (e.g., C):%RESET% "

if "%DRIVE%"=="" (
    echo %ERROR%No drive specified!%RESET%
    timeout /t 2 >nul
    goto DiskMenu
)

REM Remove colon if present
set "DRIVE=%DRIVE::=%"

echo.
echo %TEXT%Analyzing drive %DRIVE%:...%RESET%
echo.

REM Check if drive exists
if not exist "%DRIVE%:\" (
    echo %ERROR%Drive %DRIVE%: not found!%RESET%
    timeout /t 2 >nul
    goto DiskMenu
)

REM Get drive info
for /f "tokens=1-3" %%a in ('wmic logicaldisk where "DeviceID='%DRIVE%:'" get FreeSpace^,Size^,VolumeName /format:list ^| findstr "="') do (
    set "%%a"
)

REM Calculate sizes in GB
set /a "TOTAL_GB=Size/1073741824"
set /a "FREE_GB=FreeSpace/1073741824"
set /a "USED_GB=TOTAL_GB-FREE_GB"
set /a "PERCENT_USED=(USED_GB*100)/TOTAL_GB"

echo %TEXT%Drive:%RESET% %BRACKET%%DRIVE%:%RESET%
if defined VolumeName echo %TEXT%Label:%RESET% %BRACKET%%VolumeName%%RESET%
echo %TEXT%Total Size:%RESET% %BRACKET%%TOTAL_GB% GB%RESET%
echo %TEXT%Used Space:%RESET% %BRACKET%%USED_GB% GB%RESET%
echo %TEXT%Free Space:%RESET% %BRACKET%%FREE_GB% GB%RESET%
echo %TEXT%Usage:%RESET% %BRACKET%%PERCENT_USED%%%RESET%

echo.
echo %TEXT%Top 10 largest folders on %DRIVE%:...%RESET%
echo %WARNING%(This may take a few moments)%RESET%
echo.

powershell -NoProfile -Command "$drive = '%DRIVE%:'; Get-ChildItem -Path $drive -Directory -ErrorAction SilentlyContinue | ForEach-Object { $path = $_.FullName; try { $size = (Get-ChildItem -Path $path -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum; [PSCustomObject]@{ Path = $path; SizeGB = [math]::Round($size / 1GB, 2) } } catch { } } | Where-Object { $_.SizeGB -gt 0 } | Sort-Object SizeGB -Descending | Select-Object -First 10 | Format-Table -AutoSize"

echo.
echo %HEADER%%SEPARATOR%%RESET%
echo.
echo %BRACKET%[%RESET%%TEXT%0%RESET%%BRACKET%]%RESET% %TEXT%Back to Disk Menu%RESET%
echo.
choice /c 0 /n /m ""
goto DiskMenu

:FindLargest
cls
echo.
echo %HEADER%%SEPARATOR%%RESET%
echo %HEADER%        FIND LARGEST FOLDERS%RESET%
echo %HEADER%%SEPARATOR%%RESET%
echo.

set /p "SEARCH_PATH=%BRACKET%[%RESET%%TEXT%?%RESET%%BRACKET%]%RESET% %TEXT%Enter path to analyze (e.g., C:\Users): %RESET%"

if "%SEARCH_PATH%"=="" (
    echo %ERROR%No path specified!%RESET%
    timeout /t 2 >nul
    goto DiskMenu
)

if not exist "%SEARCH_PATH%" (
    echo %ERROR%Path not found!%RESET%
    timeout /t 2 >nul
    goto DiskMenu
)

echo.
echo %TEXT%Analyzing: %SEARCH_PATH%%RESET%
echo %WARNING%This may take several minutes for large directories...%RESET%
echo.

powershell -NoProfile -Command "$path = '%SEARCH_PATH%'; Write-Host 'Top 15 largest folders:' -ForegroundColor Cyan; Write-Host ''; Get-ChildItem -Path $path -Directory -ErrorAction SilentlyContinue | ForEach-Object { $folderPath = $_.FullName; $folderName = $_.Name; Write-Host \"Scanning: $folderName\" -ForegroundColor DarkGray; try { $size = (Get-ChildItem -Path $folderPath -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum; [PSCustomObject]@{ Folder = $folderName; Path = $folderPath; SizeGB = [math]::Round($size / 1GB, 2); SizeMB = [math]::Round($size / 1MB, 2) } } catch { } } | Where-Object { $_.SizeGB -gt 0 } | Sort-Object SizeGB -Descending | Select-Object -First 15 | ForEach-Object { Write-Host \"\" -NoNewline; if ($_.SizeGB -ge 1) { Write-Host \"$([char]0x25A0) \" -ForegroundColor Green -NoNewline; Write-Host \"$($_.Folder)\" -ForegroundColor White -NoNewline; Write-Host \" - \" -ForegroundColor DarkGray -NoNewline; Write-Host \"$($_.SizeGB) GB\" -ForegroundColor Cyan } else { Write-Host \"$([char]0x25A1) \" -ForegroundColor Yellow -NoNewline; Write-Host \"$($_.Folder)\" -ForegroundColor White -NoNewline; Write-Host \" - \" -ForegroundColor DarkGray -NoNewline; Write-Host \"$($_.SizeMB) MB\" -ForegroundColor Yellow }; Write-Host \"   $($_.Path)\" -ForegroundColor DarkGray }"

echo.
echo %HEADER%%SEPARATOR%%RESET%
echo.
echo %BRACKET%[%RESET%%TEXT%0%RESET%%BRACKET%]%RESET% %TEXT%Back to Disk Menu%RESET%
echo.
choice /c 0 /n /m ""
goto DiskMenu

:DiskCleanup
cls
echo.
echo %HEADER%%SEPARATOR%%RESET%
echo %HEADER%         QUICK DISK CLEANUP%RESET%
echo %HEADER%%SEPARATOR%%RESET%
echo.

echo %TEXT%This will clean:%RESET%
echo   %BULLET% Temporary files (%TEMP%)
echo   %BULLET% Windows temp files
echo   %BULLET% Recycle Bin
echo   %BULLET% Prefetch cache
echo.
echo %WARNING%This requires Administrator privileges.%RESET%
echo.

set /p "CONFIRM=%BRACKET%[%RESET%%TEXT%?%RESET%%BRACKET%]%RESET% %TEXT%Continue? (Y/N): %RESET%"

if /i not "%CONFIRM%"=="Y" goto DiskMenu

echo.
echo %TEXT%Cleaning temporary files...%RESET%

REM Clean user temp
del /f /s /q "%TEMP%\*" >nul 2>&1
echo %SUCCESS%Cleaned user temp folder%RESET%

REM Clean Windows temp (requires admin)
del /f /s /q "C:\Windows\Temp\*" >nul 2>&1
if errorlevel 1 (
    echo %WARNING%Windows temp requires admin rights%RESET%
) else (
    echo %SUCCESS%Cleaned Windows temp folder%RESET%
)

REM Clean Recycle Bin (requires PowerShell)
powershell -NoProfile -Command "Clear-RecycleBin -Force -ErrorAction SilentlyContinue" >nul 2>&1
if errorlevel 1 (
    echo %WARNING%Could not empty Recycle Bin%RESET%
) else (
    echo %SUCCESS%Emptied Recycle Bin%RESET%
)

REM Clean prefetch
del /f /q "C:\Windows\Prefetch\*" >nul 2>&1
if errorlevel 1 (
    echo %WARNING%Prefetch cleanup requires admin rights%RESET%
) else (
    echo %SUCCESS%Cleaned prefetch cache%RESET%
)

echo.
echo %SUCCESS%Cleanup complete!%RESET%
echo.
echo %BRACKET%[%RESET%%TEXT%0%RESET%%BRACKET%]%RESET% %TEXT%Back to Disk Menu%RESET%
echo.
choice /c 0 /n /m ""
goto DiskMenu

:FolderSize
cls
echo.
echo %HEADER%%SEPARATOR%%RESET%
echo %HEADER%       FOLDER SIZE CALCULATOR%RESET%
echo %HEADER%%SEPARATOR%%RESET%
echo.

set /p "FOLDER=%BRACKET%[%RESET%%TEXT%?%RESET%%BRACKET%]%RESET% %TEXT%Enter folder path: %RESET%"

if "%FOLDER%"=="" (
    echo %ERROR%No folder specified!%RESET%
    timeout /t 2 >nul
    goto DiskMenu
)

if not exist "%FOLDER%" (
    echo %ERROR%Folder not found!%RESET%
    timeout /t 2 >nul
    goto DiskMenu
)

echo.
echo %TEXT%Calculating size of: %FOLDER%%RESET%
echo %WARNING%Please wait...%RESET%
echo.

powershell -NoProfile -Command "$path = '%FOLDER%'; $size = (Get-ChildItem -Path $path -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum; $sizeGB = [math]::Round($size / 1GB, 2); $sizeMB = [math]::Round($size / 1MB, 2); $fileCount = (Get-ChildItem -Path $path -Recurse -File -ErrorAction SilentlyContinue | Measure-Object).Count; $folderCount = (Get-ChildItem -Path $path -Recurse -Directory -ErrorAction SilentlyContinue | Measure-Object).Count; Write-Host 'Folder: ' -NoNewline -ForegroundColor White; Write-Host $path -ForegroundColor Cyan; Write-Host ''; Write-Host 'Total Size:' -NoNewline -ForegroundColor White; Write-Host \" $sizeGB GB ($sizeMB MB)\" -ForegroundColor Green; Write-Host 'Files:' -NoNewline -ForegroundColor White; Write-Host \" $fileCount\" -ForegroundColor Yellow; Write-Host 'Subfolders:' -NoNewline -ForegroundColor White; Write-Host \" $folderCount\" -ForegroundColor Yellow"

echo.
echo %HEADER%%SEPARATOR%%RESET%
echo.
echo %BRACKET%[%RESET%%TEXT%0%RESET%%BRACKET%]%RESET% %TEXT%Back to Disk Menu%RESET%
echo.
choice /c 0 /n /m ""
goto DiskMenu

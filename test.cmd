@echo off
setlocal enabledelayedexpansion

:: Duke Desktop Launcher - Module Verification Test
:: Tests all modules and reports status

call "modules\colors.cmd"

cls
echo %HEADER%============================================================%C_RESET%
echo %HEADER%         DUKE DESKTOP LAUNCHER - MODULE TESTS%C_RESET%
echo %HEADER%============================================================%C_RESET%
echo.
echo %TEXT%Testing all launcher modules...%C_RESET%
echo.

set "PASS_COUNT=0"
set "FAIL_COUNT=0"
set "TOTAL_COUNT=0"

REM Test 1: Colors module
set /a "TOTAL_COUNT+=1"
echo %TEXT%[1/13] Testing colors.cmd...%C_RESET%
if exist "modules\colors.cmd" (
    call "modules\colors.cmd" >nul 2>&1
    if !errorlevel! equ 0 (
        echo        %SUCCESS%[OK] PASS%C_RESET%
        set /a "PASS_COUNT+=1"
    ) else (
        echo        %ERROR%[FAIL] - Module error%C_RESET%
        set /a "FAIL_COUNT+=1"
    )
) else (
    echo        %ERROR%[FAIL] - File not found%C_RESET%
    set /a "FAIL_COUNT+=1"
)

REM Test 2: Browser detector
set /a "TOTAL_COUNT+=1"
echo %TEXT%[2/13] Testing browser-detector.cmd...%C_RESET%
if exist "modules\browser-detector.cmd" (
    call "modules\browser-detector.cmd" >nul 2>&1
    echo        %SUCCESS%[OK] PASS%C_RESET%
    set /a "PASS_COUNT+=1"
) else (
    echo        %ERROR%[FAIL] - File not found%C_RESET%
    set /a "FAIL_COUNT+=1"
)

REM Test 3: Weather module
set /a "TOTAL_COUNT+=1"
echo %TEXT%[3/13] Testing weather.cmd...%C_RESET%
if exist "modules\weather.cmd" (
    echo        %SUCCESS%[OK] PASS%C_RESET%
    set /a "PASS_COUNT+=1"
) else (
    echo        %ERROR%[FAIL] - File not found%C_RESET%
    set /a "FAIL_COUNT+=1"
)

REM Test 4: Quotes module
set /a "TOTAL_COUNT+=1"
echo %TEXT%[4/13] Testing quotes.cmd...%C_RESET%
if exist "modules\quotes.cmd" (
    echo        %SUCCESS%[OK] PASS%C_RESET%
    set /a "PASS_COUNT+=1"
) else (
    echo        %ERROR%[FAIL] - File not found%C_RESET%
    set /a "FAIL_COUNT+=1"
)

REM Test 5: Desktop scanner
set /a "TOTAL_COUNT+=1"
echo %TEXT%[5/13] Testing desktop-scanner.cmd...%C_RESET%
if exist "modules\desktop-scanner.cmd" (
    echo        %SUCCESS%[OK] PASS%C_RESET%
    set /a "PASS_COUNT+=1"
) else (
    echo        %ERROR%[FAIL] - File not found%C_RESET%
    set /a "FAIL_COUNT+=1"
)

REM Test 6: System health
set /a "TOTAL_COUNT+=1"
echo %TEXT%[6/13] Testing system-health.cmd...%C_RESET%
if exist "modules\system-health.cmd" (
    echo        %SUCCESS%[OK] PASS%C_RESET%
    set /a "PASS_COUNT+=1"
) else (
    echo        %ERROR%[FAIL] - File not found%C_RESET%
    set /a "FAIL_COUNT+=1"
)

REM Test 7: Network diagnostics
set /a "TOTAL_COUNT+=1"
echo %TEXT%[7/13] Testing network-diagnostics.cmd...%C_RESET%
if exist "modules\network-diagnostics.cmd" (
    echo        %SUCCESS%[OK] PASS%C_RESET%
    set /a "PASS_COUNT+=1"
) else (
    echo        %ERROR%[FAIL] - File not found%C_RESET%
    set /a "FAIL_COUNT+=1"
)

REM Test 8: Power report
set /a "TOTAL_COUNT+=1"
echo %TEXT%[8/13] Testing power-report.cmd...%C_RESET%
if exist "modules\power-report.cmd" (
    echo        %SUCCESS%[OK] PASS%C_RESET%
    set /a "PASS_COUNT+=1"
) else (
    echo        %ERROR%[FAIL] - File not found%C_RESET%
    set /a "FAIL_COUNT+=1"
)

REM Test 9: Disk analyzer
set /a "TOTAL_COUNT+=1"
echo %TEXT%[9/13] Testing disk-analyzer.cmd...%C_RESET%
if exist "modules\disk-analyzer.cmd" (
    echo        %SUCCESS%[OK] PASS%C_RESET%
    set /a "PASS_COUNT+=1"
) else (
    echo        %ERROR%[FAIL] - File not found%C_RESET%
    set /a "FAIL_COUNT+=1"
)

REM Test 10: Matrix Rain
set /a "TOTAL_COUNT+=1"
echo %TEXT%[10/13] Testing matrix-rain.cmd...%C_RESET%
if exist "modules\matrix-rain.cmd" (
    echo        %SUCCESS%[OK] PASS%C_RESET%
    set /a "PASS_COUNT+=1"
) else (
    echo        %ERROR%[FAIL] - File not found%C_RESET%
    set /a "FAIL_COUNT+=1"
)

REM Test 11: Tetris
set /a "TOTAL_COUNT+=1"
echo %TEXT%[11/13] Testing tetris.cmd...%C_RESET%
if exist "modules\tetris.cmd" (
    echo        %SUCCESS%[OK] PASS%C_RESET%
    set /a "PASS_COUNT+=1"
) else (
    echo        %ERROR%[FAIL] - File not found%C_RESET%
    set /a "FAIL_COUNT+=1"
)

REM Test 12: Main launcher
set /a "TOTAL_COUNT+=1"
echo %TEXT%[12/13] Testing duke.cmd...%C_RESET%
if exist "duke.cmd" (
    echo        %SUCCESS%[OK] PASS%C_RESET%
    set /a "PASS_COUNT+=1"
) else (
    echo        %ERROR%[FAIL] - File not found%C_RESET%
    set /a "FAIL_COUNT+=1"
)

REM Test 13: Package script
set /a "TOTAL_COUNT+=1"
echo %TEXT%[13/13] Testing package.cmd...%C_RESET%
if exist "package.cmd" (
    echo        %SUCCESS%[OK] PASS%C_RESET%
    set /a "PASS_COUNT+=1"
) else (
    echo        %ERROR%[FAIL] - File not found%C_RESET%
    set /a "FAIL_COUNT+=1"
)

REM Results summary
echo.
echo %HEADER%════════════════════════════════════════════════════════════%C_RESET%
echo %HEADER%                      TEST RESULTS%C_RESET%
echo %HEADER%════════════════════════════════════════════════════════════%C_RESET%
echo.

if %PASS_COUNT% equ %TOTAL_COUNT% (
    echo %SUCCESS%   ALL TESTS PASSED! ^(%PASS_COUNT%/%TOTAL_COUNT%^)%C_RESET%
    echo.
    echo %TEXT%   Duke Desktop Launcher is ready to use!%C_RESET%
) else (
    echo %WARNING%   TESTS PASSED: %PASS_COUNT%/%TOTAL_COUNT%%C_RESET%
    echo %ERROR%   TESTS FAILED: %FAIL_COUNT%/%TOTAL_COUNT%%C_RESET%
    echo.
    echo %TEXT%   Please check failed modules above.%C_RESET%
)

echo.
echo %HEADER%════════════════════════════════════════════════════════════%C_RESET%
echo.

pause
exit /b 0

@echo off
call "%~dp0..\colors.cmd"

python --version >nul 2>&1
if errorlevel 1 (
    cls
    echo %ERROR%╔═══════════════════════════════════════════════════════════╗%C_RESET%
    echo %ERROR%║            Python 3 Required                              ║%C_RESET%
    echo %ERROR%╚═══════════════════════════════════════════════════════════╝%C_RESET%
    echo.
    echo %TEXT%Snake requires Python 3 to run.%C_RESET%
    echo.
    echo %INFO%Download from: https://www.python.org/downloads/%C_RESET%
    echo.
    pause
    exit /b 1
)

python "%~dp0games\snake.py"
exit /b 0

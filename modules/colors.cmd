@echo off
REM ============================================================
REM DUKE DESKTOP LAUNCHER - ANSI Color System
REM Customizable color scheme loaded from config
REM Pure ANSI escape codes - NO nhcolor.exe dependency
REM ============================================================

REM Generate ESC character for ANSI codes
for /F %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"

REM Load color scheme from config (or use defaults)
set "SCHEME_FILE=%~dp0..\config\color-scheme.txt"

REM Default color scheme (Cyan & White)
set "HEADER_COLOR=96m"
set "TEXT_COLOR=97m"
set "SUCCESS_COLOR=92m"
set "WARNING_COLOR=93m"
set "ERROR_COLOR=91m"
set "INFO_COLOR=94m"
set "BRACKET_COLOR=90m"
set "SEPARATOR_COLOR=96m"

REM Load custom colors if config exists
if exist "%SCHEME_FILE%" (
    for /f "usebackq tokens=1,2 delims==" %%a in ("%SCHEME_FILE%") do (
        set "LINE=%%a"
        set "VALUE=%%b"
        REM Skip comments (lines starting with #)
        if not "!LINE:~0,1!"=="#" (
            if "%%a"=="HEADER_COLOR" set "HEADER_COLOR=%%b"
            if "%%a"=="TEXT_COLOR" set "TEXT_COLOR=%%b"
            if "%%a"=="SUCCESS_COLOR" set "SUCCESS_COLOR=%%b"
            if "%%a"=="WARNING_COLOR" set "WARNING_COLOR=%%b"
            if "%%a"=="ERROR_COLOR" set "ERROR_COLOR=%%b"
            if "%%a"=="INFO_COLOR" set "INFO_COLOR=%%b"
            if "%%a"=="BRACKET_COLOR" set "BRACKET_COLOR=%%b"
            if "%%a"=="SEPARATOR_COLOR" set "SEPARATOR_COLOR=%%b"
        )
    )
)

REM Color Definitions (Full Palette)
set "C_RESET=%ESC%[0m"
set "C_BOLD=%ESC%[1m"

REM Foreground Colors - Normal
set "C_BLACK=%ESC%[30m"
set "C_RED=%ESC%[31m"
set "C_GREEN=%ESC%[32m"
set "C_YELLOW=%ESC%[33m"
set "C_BLUE=%ESC%[34m"
set "C_MAGENTA=%ESC%[35m"
set "C_CYAN=%ESC%[36m"
set "C_WHITE=%ESC%[37m"

REM Foreground Colors - Bright
set "C_BRIGHT_BLACK=%ESC%[90m"
set "C_BRIGHT_RED=%ESC%[91m"
set "C_BRIGHT_GREEN=%ESC%[92m"
set "C_BRIGHT_YELLOW=%ESC%[93m"
set "C_BRIGHT_BLUE=%ESC%[94m"
set "C_BRIGHT_MAGENTA=%ESC%[95m"
set "C_BRIGHT_CYAN=%ESC%[96m"
set "C_BRIGHT_WHITE=%ESC%[97m"

REM Background Colors
set "C_BG_BLACK=%ESC%[40m"
set "C_BG_RED=%ESC%[41m"
set "C_BG_GREEN=%ESC%[42m"
set "C_BG_YELLOW=%ESC%[43m"
set "C_BG_BLUE=%ESC%[44m"
set "C_BG_MAGENTA=%ESC%[45m"
set "C_BG_CYAN=%ESC%[46m"
set "C_BG_WHITE=%ESC%[47m"

REM Apply loaded color scheme
set "HEADER=%ESC%[%HEADER_COLOR%%C_BOLD%"
set "TEXT=%ESC%[%TEXT_COLOR%"
set "SUCCESS=%ESC%[%SUCCESS_COLOR%"
set "WARNING=%ESC%[%WARNING_COLOR%"
set "ERROR=%ESC%[%ERROR_COLOR%"
set "INFO=%ESC%[%INFO_COLOR%"
set "BRACKET=%ESC%[%BRACKET_COLOR%"
set "SEPARATOR=%ESC%[%SEPARATOR_COLOR%"

REM Additional aliases
set "MENU_NUM=%BRACKET%"
set "PROMPT=%BRACKET%"
set "MATRIX=%C_BRIGHT_GREEN%"

REM Return to caller with all variables exported
goto :eof

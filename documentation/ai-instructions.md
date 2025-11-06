# AI Agent Instructions - Batch Script & CMD Expert

## AGENT IDENTITY
**Role:** Windows Batch Script Specialist for Desktop Launcher Development  
**Expertise:** CMD, Batch files, PowerShell integration, ANSI colors, menu systems  
**Project:** JARVIS Desktop Launcher for Ghost Spectre Windows

---

## 🎯 PROJECT CONTEXT

**Goal:** Create a desktop launcher CMD file that:
- Scans desktop for .exe and .lnk files automatically
- Displays ASCII art banner with colors
- Shows numbered menu of applications
- Launches selected application
- No manual configuration needed

**Key Constraint:** Must work on Ghost Spectre Windows (Windows 10+)

---

## 📚 BATCH SCRIPT BEST PRACTICES

### 1. File Structure & Organization
```batch
@echo off
setlocal enabledelayedexpansion
REM Script description

REM === VARIABLES ===
set "desktop=%USERPROFILE%\Desktop"

REM === MAIN LOGIC ===
call :main
exit /b 0

REM === FUNCTIONS ===
:main
    REM main code here
    goto :eof

:function_name
    REM function code
    goto :eof
```

### 2. Variable Handling
**DO:**
- Use `setlocal` at script start
- Use quotes: `set "var=value"` (prevents trailing spaces)
- Use delayed expansion for loops: `!var!`
- Use descriptive names: `app_count` not `c`

**DON'T:**
- Hardcode paths - use `%USERPROFILE%`
- Forget to reset variables between loops
- Use spaces without quotes

### 3. Error Handling
```batch
if not exist "%desktop%" (
    echo ERROR: Desktop folder not found
    exit /b 1
)

if errorlevel 1 (
    echo Command failed
    goto :error_handler
)
```

### 4. File Operations - Desktop Scanning
**Best practice for scanning:**
```batch
REM Scan for .exe and .lnk files (including hidden)
set count=0
for /f "delims=" %%f in ('dir "%desktop%\*.exe" "%desktop%\*.lnk" /b /a 2^>nul') do (
    set /a count+=1
    set "app[!count!]=%%f"
    set "app_name[!count!]=%%~nf"
)
```

**Why this works:**
- `/b` = bare format (names only)
- `/a` = include hidden files
- `2^>nul` = suppress errors if no files
- `delims=` = preserve full filename with spaces

### 5. User Input
**Choice command (single key):**
```batch
choice /c 123Q /n /m "Select (1-3, Q to quit): "
set selection=%errorlevel%
```

**Set /p (typed input):**
```batch
set /p selection="Enter number: "
if not defined selection goto :menu
```

### 6. Launching Applications
```batch
REM Best method - start in separate process
start "" "%desktop%\!app[%selection%]!"

REM For shortcuts (.lnk)
start "" "%desktop%\!app[%selection%]!"
```

**Why `start ""`:**
- Empty quotes = window title (required parameter)
- Launches in background
- Returns to script immediately

---

## 🌈 COLOR IMPLEMENTATION GUIDE

### ANSI Escape Codes (RECOMMENDED)

**Setup:**
```batch
REM Create ESC character once at script start
for /F %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"

REM Define color variables for reuse
set "GREEN=%ESC%[32m"
set "CYAN=%ESC%[36m"
set "YELLOW=%ESC%[33m"
set "RED=%ESC%[31m"
set "RESET=%ESC%[0m"
set "BRIGHT_GREEN=%ESC%[92m"
set "BRIGHT_CYAN=%ESC%[96m"
```

**Usage:**
```batch
echo %BRIGHT_GREEN%========================================%RESET%
echo %BRIGHT_CYAN%   JARVIS Desktop Launcher v1.0%RESET%
echo %BRIGHT_GREEN%========================================%RESET%
```

**CRITICAL RULES:**
1. Always end colored lines with `%RESET%` or `%ESC%[0m`
2. Create ESC variable BEFORE `setlocal enabledelayedexpansion`
3. Test colors on actual Ghost Spectre system

**Matrix-Style Theme:**
```batch
REM Primary: Bright Green
set "PRIMARY=%ESC%[92m"
REM Secondary: Bright Cyan  
set "SECONDARY=%ESC%[96m"
REM Accent: Yellow
set "ACCENT=%ESC%[93m"
REM Error: Red
set "ERROR=%ESC%[91m"
```

---

## 🚀 PERFORMANCE OPTIMIZATION

### DO:
- Use batch for file scanning (faster than PowerShell)
- Cache ESC character in variable
- Use `goto` instead of repeated `call` for speed
- Clear screen once: `cls`

### DON'T:
- Call PowerShell repeatedly in loops
- Use `ping` for delays in production
- Create temporary files unnecessarily

---

## 🔒 SECURITY & ROBUSTNESS

### Path Safety:
```batch
REM Always quote paths
if exist "%USERPROFILE%\Desktop" (
    cd /d "%USERPROFILE%\Desktop"
)

REM Validate user input
if "%selection%" GEQ "1" if "%selection%" LEQ "%count%" (
    REM valid
) else (
    echo Invalid selection
)
```

### Special Character Handling:
```batch
REM Escape in echo: ^ & | < > ( )
echo This ^& that

REM In variables - delayed expansion handles most
set "text=Text with & and | characters"
echo !text!
```

---

## 📝 CODE STYLE GUIDE

### Naming Conventions:
- Variables: `lowercase_with_underscores` or `camelCase`
- Labels: `:PascalCase` or `:lowercase`
- Constants: `UPPERCASE`

### Comments:
```batch
REM === SECTION HEADER ===

REM Single line explanation
set "var=value"

REM Multi-line explanation:
REM Line 1
REM Line 2
```

### Indentation:
```batch
:main
    echo Starting
    if "%1"=="" (
        echo No args
        call :default_action
    ) else (
        echo Args: %*
        call :process_args %*
    )
    goto :eof
```

---

## 🐛 COMMON PITFALLS & SOLUTIONS

### Pitfall 1: Spaces in filenames
**Problem:** `for %%f in (*.exe)` splits on spaces  
**Solution:** Use `for /f "delims="` or quotes

### Pitfall 2: Special characters in paths
**Problem:** Characters like `&` break commands  
**Solution:** Always quote: `"%var%"`

### Pitfall 3: Variables in loops
**Problem:** `%var%` doesn't update in loop  
**Solution:** Use delayed expansion: `!var!`

### Pitfall 4: Color codes showing as text
**Problem:** ANSI not enabled or wrong character  
**Solution:** 
- Use Ctrl+[ not typed `[`
- Verify Windows 10+
- Check `for /F %%a in ('echo prompt $E ^| cmd')` syntax

### Pitfall 5: Errorlevel not resetting
**Problem:** Previous command's errorlevel persists  
**Solution:** `set errorlevel=` or check immediately after command

---

## ✅ DEVELOPMENT WORKFLOW

### Phase 1: Core Structure
1. Create main script skeleton
2. Implement desktop scanner
3. Test with sample files

### Phase 2: Menu System
1. Display file list
2. Add user input
3. Add selection validation

### Phase 3: Colors & Polish
1. Add ANSI color support
2. Create ASCII banner
3. Test color rendering

### Phase 4: Launch Functionality
1. Implement `start` command
2. Add error handling
3. Test with various file types

### Phase 5: Testing
1. Test with hidden desktop icons
2. Test with 0 files
3. Test with special characters in filenames
4. Test colors on Ghost Spectre

---

## 🎓 LEARNING RESOURCES USED

- **Microsoft Docs:** Windows Commands A-Z Reference
- **SS64.com:** ANSI Color Codes, Batch Syntax
- **StackOverflow:** ANSI Escape Sequences in Windows 10+
- **Context7:** Batch Script Guide, PowerShell Best Practices

---

## ⚡ QUICK REFERENCE

### Essential Commands:
```batch
dir /b /a                REM List files (bare, all)
for /f "delims=" %%f     REM Loop with full line
set /p var="Prompt: "    REM User input
choice /c ABC            REM Single key choice
if defined var           REM Check if variable exists
if exist "file"          REM Check file exists
start "" "program.exe"   REM Launch program
cls                      REM Clear screen
goto :label              REM Jump to label
call :function           REM Call subroutine
exit /b 0                REM Exit with code 0
```

### Color Shortcuts:
```batch
set "G=%ESC%[92m"   REM Bright Green
set "C=%ESC%[96m"   REM Bright Cyan
set "Y=%ESC%[93m"   REM Bright Yellow
set "R=%ESC%[91m"   REM Bright Red
set "X=%ESC%[0m"    REM Reset
```

---

## 🎯 SUCCESS CRITERIA

✅ **Must Have:**
- [ ] Automatically scans desktop
- [ ] Displays colored ASCII banner
- [ ] Shows numbered menu
- [ ] Launches selected app
- [ ] Works with hidden icons
- [ ] No manual editing needed
- [ ] Single .cmd file (MVP)

⭐ **Nice to Have:**
- [ ] Animation effects
- [ ] Recent apps list
- [ ] Favorites system
- [ ] Search functionality

---

**END OF AI INSTRUCTIONS**
*Use this document as reference when developing the JARVIS Desktop Launcher*
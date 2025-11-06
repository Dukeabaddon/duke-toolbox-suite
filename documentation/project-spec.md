# Desktop Launcher - Complete Project Documentation

**Project Name:** JARVIS Desktop Launcher  
**Version:** 1.0.0 MVP  
**Date:** November 6, 2025  
**Author:** Aaron  
**OS:** Ghost Spectre Windows

---

## 📋 CORE MVP FEATURES

### Must-Have Features:
1. **Dynamic Desktop Scanning**
   - Auto-detect `.exe` and `.lnk` files from `%USERPROFILE%\Desktop`
   - Work even when desktop icons are hidden (`/a` flag in dir)
   - No manual editing - automatically update when apps added/removed

2. **ASCII Art Greeting**
   - "JARVIS" banner using text art (copy from online generators)
   - Display on launch

3. **Colored Menu System**
   - Matrix-style green/cyan recommended
   - Numbered menu with application list
   - Clean, readable interface

4. **Application Launcher**
   - Select by number
   - Launch with `start` command
   - Return to menu or exit

---

## 🎯 USER EXPERIENCE FLOW

```
[Boot Sequence]
    ↓
[ASCII Banner Display] (Green/Cyan)
    ↓
[Scan Desktop Files]
    ↓
[Display Colored Menu]
    ↓
[User Selection] → [Launch App] → [Return to Menu]
    ↓
[Exit Option]
```

---

## 🔧 TECHNOLOGY DECISIONS

### Primary: Windows Batch Script (.cmd)
**Why chosen:**
- Native to Windows - no dependencies
- Fast execution
- Simple file operations
- Perfect for menu systems

**Capabilities:**
- File scanning: `dir`, `for /f` loops
- User input: `set /p`, `choice` command  
- Conditionals: `if`, `goto` labels
- Variables: `set`, `setlocal`, delayed expansion

### Secondary: PowerShell
**When to use:**
- Color output (`Write-Host -ForegroundColor`)
- Advanced file filtering (`Get-ChildItem`)
- Complex operations

**Integration:** `powershell -Command "command here"`

---

## 🌈 COLOR IMPLEMENTATION (FINAL DECISION)

### **RECOMMENDED: ANSI Escape Codes (Windows 10+)**

**Status:** ✅ BUILT-IN, NO DEPENDENCIES  
**Compatibility:** Windows 10 build 1511+ (2015+), Ghost Spectre included  
**Performance:** FASTEST option

#### How to Use:
```batch
REM Create ESC character variable
for /F %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"

REM Use ANSI codes
echo %ESC%[32mGreen Text%ESC%[0m
echo %ESC%[91mBright Red%ESC%[0m
echo %ESC%[36mCyan Text%ESC%[0m
```

#### Color Codes:
| Color | Foreground | Background | Hex |
|-------|-----------|------------|-----|
| Black | `%ESC%[30m` | `%ESC%[40m` | 0 |
| Red | `%ESC%[31m` | `%ESC%[41m` | 4 |
| Green | `%ESC%[32m` | `%ESC%[42m` | 2 |
| Yellow | `%ESC%[33m` | `%ESC%[43m` | 6 |
| Blue | `%ESC%[34m` | `%ESC%[44m` | 1 |
| Magenta | `%ESC%[35m` | `%ESC%[45m` | 5 |
| Cyan | `%ESC%[36m` | `%ESC%[46m` | 3 |
| White | `%ESC%[37m` | `%ESC%[47m` | 7 |
| **Bright Green** | `%ESC%[92m` | `%ESC%[102m` | A |
| **Bright Cyan** | `%ESC%[96m` | `%ESC%[106m` | B |

#### Special Codes:
- `%ESC%[0m` - Reset to default
- `%ESC%[1m` - Bold
- `%ESC%[4m` - Underline
- `%ESC%[7m` - Reverse (swap fore/back)

### Alternative Options:

#### Option 2: PowerShell Write-Host
**Status:** Always available
```batch
powershell -Command "Write-Host 'Text' -ForegroundColor Green"
```
**Pros:** No setup, rich colors  
**Cons:** SLOW (spawns PowerShell process each time)  
**Use for:** Headers only, not repeated text

#### Option 3: nhcolor.exe
**Status:** ❓ UNKNOWN - needs verification on Ghost Spectre
**What it is:** Third-party CMD color utility
**Usage:** `nhcolor 0A "Green text"`
**Decision:** Skip this - ANSI codes are better and built-in

---

## 🏗️ PROJECT ARCHITECTURE

### File Structure:
```
cmd/
├── launcher.cmd              # Main entry point (all-in-one for MVP)
├── documentation/
│   ├── project-spec.md       # This file
│   └── ai-instructions.md    # AI agent best practices
└── README.md                 # User instructions
```

**MVP Decision:** Single file `launcher.cmd` - easier to deploy and maintain

---

## 💻 TECHNICAL IMPLEMENTATION

### 1. Desktop Scanner (Batch Script)
**Best Method:**

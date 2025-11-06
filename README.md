# 🚀 Duke Desktop Launcher

A powerful, customizable Windows desktop launcher and utility hub inspired by Ghost Toolbox. Built with pure Windows Batch scripting and ANSI color codes for a modern terminal experience.

![Version](https://img.shields.io/badge/version-1.0.0-blue)
![Platform](https://img.shields.io/badge/platform-Windows%2010%2B-brightgreen)
![License](https://img.shields.io/badge/license-MIT-green)
![Status](https://img.shields.io/badge/status-production%20ready-success)

## ✨ Features

### 🖥️ Desktop Integration
- **Two-Column Menu Layout** - Ghost Toolbox-inspired aesthetic with system info header
- **First-Time Setup Wizard** - Interactive configuration for username and location
- **Browser Submenu System** - Launch, Quick Links, Edit Links for all detected browsers
- **Spotify Integration** - Launch app, search songs, or open web player
- **Auto-Scan Desktop** - Detects `.exe` and `.lnk` files automatically

### 🎮 Entertainment & Utilities
- **Matrix Rain Animation** - 5-second cascading green characters (30 columns, variable speed)
- **Tetris Game** - Tetris demonstration with visual board display
- **Weather Display** - Real-time weather with conditional ASCII art (sunny/rainy/cloudy)
- **Random Quotes** - Inspirational quotes from quotable.io with offline fallback

### 🔧 System Tools (Complete)
- **System Health Check** - SFC, CHKDSK, DISM diagnostics (admin required)
- **Network Diagnostics** - ipconfig, DNS flush, netstat, tracert, pathping, ping, adapters
- **Power Report** - Battery report/health, energy analysis, sleep study (laptop detection)
- **Disk Space Analyzer** - All drives with progress bars, largest folders, cleanup, size calculator

### 🎨 Design & Customization
- **Pure ANSI Colors** - Cyan headers, white text, green success (no external tools)
- **Animated ASCII Banner** - Line-by-line greeting animation with welcome message
- **System Info Display** - OS, timezone, CPU, RAM, username in header
- **Full-Width Headers** - 60-character separators for professional look
- **No Dependencies** - Works out of the box (except curl for weather/quotes)

## 📋 Requirements

- Windows 10 Build 1511 or later (for ANSI color support)
- Windows 11 Pro (tested ✓)
- PowerShell 5.1+ (included in Windows)
- `curl` (built into Windows 10+)

## 🚀 Installation

### Quick Start (Recommended)

1. **Download the Latest Release**
   - Go to the [Releases](https://github.com/yourusername/duke-launcher/releases) page
   - Download `duke-launcher-v1.0.0.zip` (18KB)
   - Extract the ZIP file to your desired location

2. **Run the Launcher**
   - Double-click `duke.cmd`
   - The launcher will auto-detect your system info on first run
   - Enjoy!

### Manual Installation (Development)

1. **Clone the Repository**
   ```powershell
   git clone https://github.com/yourusername/DukeDesktopLauncher.git
   cd DukeDesktopLauncher
   ```

2. **Run from Source**
   ```powershell
   .\duke.cmd
   ```

### Build Your Own Release Package

```powershell
# Run the packaging script
.\package.cmd

# Find your release in the dist/ folder
# duke-launcher-v1.0.0.zip is ready for distribution!
```

2. **Run Duke**
   ```cmd
   duke.cmd
   ```

3. **First Run** - Duke will automatically:
   - Detect your system information (OS, CPU, RAM, timezone)
   - Create configuration files
   - Scan your desktop for applications

### Manual Installation

1. Download the repository as ZIP
2. Extract to any location (e.g., `C:\Tools\DukeDesktopLauncher`)
3. Double-click `duke.cmd` to launch

## 📖 Usage

### Main Menu Navigation

```
============================================================
DUKE DESKTOP LAUNCHER
============================================================
OS: Windows 11 Pro | Timezone: Philippine Standard Time | Computer: AARON-PC
CPU: AMD Ryzen 5 5600X | RAM: 16GB | User: Aaron
============================================================

APPLICATIONS | DESKTOP
------------------------------------------------------------
[1]  | Brave
[2]  | Discord
[3]  | Visual Studio Code
...

UTILITIES | EXTRAS
------------------------------------------------------------
[10] | Matrix Rain Animation
[11] | Weather Display
[12] | Tetris Game
[13] | Random Quote
[14] | System Health Check
[15] | Network Diagnostics
[16] | Power Report
[17] | Disk Space Analyzer

SETTINGS | ETC
------------------------------------------------------------
[18] | Refresh Desktop Scan
[19] | Edit Quick Links
[20] | Customize System Info
[21] | About

[0]  | Exit
------------------------------------------------------------
Type option: _
```

### Browser Quick Links

When you select a browser (e.g., Brave), you'll see:

```
============================================================
Brave Browser
============================================================

[1]  | Launch Application
[2]  | Facebook
[3]  | YouTube
[4]  | GitHub
[5]  | Twitter
[Edit] | Edit Quick Links

[0]  | Back
------------------------------------------------------------
Type option: _
```

## ⚙️ Configuration

### System Information

Edit `config\system-info.txt`:

```ini
SYS_OS=Windows 11 Pro
SYS_TIMEZONE=Philippine Standard Time
SYS_COMPUTER=AARON-PC
SYS_CPU=AMD Ryzen 5 5600X 6-Core Processor
SYS_RAM=16GB
SYS_USER=Aaron
```

### Browser Quick Links

Create/edit `config\brave-links.txt` (pipe-delimited format):

```
Facebook|https://facebook.com
YouTube|https://youtube.com
GitHub|https://github.com
Twitter|https://twitter.com
Reddit|https://reddit.com
```

**No limit on the number of links!**

### Weather Location

Edit `config\weather-location.txt`:

```
Manila
```

## 🎨 Customization

### Change Color Scheme

The color system is defined in `modules\colors.cmd`. Current Ghost Toolbox theme:

- **Headers**: Bright Cyan (`%ESC%[96m`)
- **Text**: Bright White (`%ESC%[97m`)
- **Brackets/Numbers**: Bright Cyan (`%ESC%[96m`)
- **Warnings**: Bright Yellow (`%ESC%[93m`)
- **Errors**: Bright Red (`%ESC%[91m`)
- **Success**: Bright Green (`%ESC%[92m`)

### Customize ASCII Banner

Replace `assets\banner.txt` with your own ASCII art (any text editor).

### Add Custom Applications

Desktop applications are auto-detected. To add custom shortcuts:
1. Create a shortcut (`.lnk`) on your desktop
2. Refresh the desktop scan (option 18)

## 🔧 Advanced Features

### Spotify Search

Duke supports two methods for Spotify search:

1. **spotify: URI scheme** (desktop app)
   ```
   spotify:search:radiohead
   ```

2. **Web fallback**
   ```
   https://open.spotify.com/search/radiohead
   ```

### Matrix Rain Animation

- **24 frames per second** (configurable)
- **5-second duration**
- **Auto-finish** (no keypress needed)
- Store your ASCII art frames in `assets\matrix-frames\`

## 📁 Project Structure

```
DukeDesktopLauncher/
├── duke.cmd                    # Main launcher (entry point)
├── package.cmd                 # Release packaging script
├── test.cmd                    # Module verification test
├── LICENSE                     # MIT License
├── README.md                   # This file
├── .gitignore                  # Git ignore rules
├── modules/
│   ├── colors.cmd              # ANSI color system
│   ├── browser-detector.cmd    # Browser detection
│   ├── desktop-scanner.cmd     # Desktop file scanner
│   ├── browser-links.cmd       # Browser quick links
│   ├── weather.cmd             # Weather display
│   ├── quotes.cmd              # Random quotes
│   ├── spotify.cmd             # Spotify search
│   ├── tetris.cmd              # Tetris game (coming soon)
│   ├── system-health.cmd       # System diagnostics
│   ├── network-diagnostics.cmd # Network tools (coming soon)
│   ├── power-report.cmd        # Power analysis (coming soon)
│   └── disk-analyzer.cmd       # Disk usage (coming soon)
├── config/
│   ├── TEMPLATE-browser-links.txt # Template for quick links
│   ├── system-info.txt         # Auto-generated system config
│   ├── detected-browsers.txt   # Auto-detected browser paths
│   ├── brave-links.txt         # User-created quick links
│   ├── chrome-links.txt        # (Created when first used)
│   ├── edge-links.txt
│   └── weather-location.txt    # Weather location preference
├── assets/
│   ├── banner.txt              # ASCII art banner
│   └── matrix-frames/          # Matrix animation frames
├── logs/                       # Auto-generated diagnostic logs
└── documentation/
    ├── batch-script-expert.md  # Batch scripting reference
    ├── project-spec.md         # Original specification
    ├── TO-DO.md                # Development roadmap
    └── SESSION-SUMMARY.md      # Development notes
```

## 🏗️ Architecture & Design Philosophy

### Modular vs. Monolithic

**Ghost Toolbox Approach**: Single large `.cmd` file with all logic + `nhcolor.exe` dependency

**Duke Launcher Approach**: Modular architecture with multiple benefits:

| Aspect | Ghost Toolbox | Duke Launcher |
|--------|--------------|---------------|
| **File Structure** | Single CMD file | Multiple modules |
| **Color System** | nhcolor.exe (requires System32 install) | Pure ANSI codes (built-in) |
| **Maintenance** | Edit one large file | Edit individual modules |
| **Debugging** | Search through entire file | Isolate issues by module |
| **Collaboration** | Merge conflicts common | Parallel development friendly |
| **Dependencies** | Requires nhcolor.exe | Zero external dependencies |
| **Distribution** | Folder with main CMD + exe | Folder with main CMD + modules |

**Both approaches** distribute as a folder (ZIP extract and run), but Duke's modular design is:
- ✅ Easier to maintain and debug
- ✅ Better for collaboration
- ✅ No external dependencies
- ✅ More organized and readable
- ✅ Follows Windows Batch best practices (#file:batch-script-expert.md)

### Development vs. Distribution

- **Development** (this repo): Modular files for easy editing
- **Distribution** (releases): Complete packaged folder via `package.cmd`
- **User Experience**: Extract ZIP → Run `duke.cmd` (same simplicity as Ghost Toolbox)

## 🐛 Troubleshooting

### Colors Not Displaying

**Issue**: ANSI colors show as escape codes instead of colors.

**Solution**: Enable Virtual Terminal Processing:
```cmd
reg add HKCU\Console /v VirtualTerminalLevel /t REG_DWORD /d 1 /f
```

### Desktop Apps Not Detected

**Issue**: Applications don't appear in the menu.

**Solutions**:
- Ensure files have `.exe` or `.lnk` extensions
- Check if desktop icons are hidden (Duke scans hidden files by default)
- Press option 18 to refresh the scan

### Spotify Search Not Working

**Issue**: spotify: URI doesn't open the app.

**Solutions**:
- Ensure Spotify desktop app is installed
- Try the web fallback option
- Test URI manually: `start "" "spotify:search:test"`

## 🤝 Contributing

Contributions are welcome! Feel free to:
- Report bugs
- Suggest new features
- Submit pull requests
- Share your custom modules

## 📜 License

MIT License - see [LICENSE](LICENSE) file for details.

## 🙏 Credits

- **Inspired by**: [Ghost Toolbox](https://github.com/Batlez/Ghost-Toolbox)
- **Tetris Game**: Adapted from [Hoffs/tetris.bat](https://gist.github.com/Hoffs/4c2245903476c6ea4fc83a636470bd6f)
- **Weather API**: [wttr.in](https://wttr.in)
- **Quotes API**: [GoodReads](https://goodreads.com) / [quotable.io](https://quotable.io)

## 📞 Support

For issues or questions:
- Create an issue on GitHub
- Contact: @Aaron

---

**Made with ❤️ by Aaron** | **Version 1.0** | **Windows 11 Pro**

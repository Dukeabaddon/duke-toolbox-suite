# Duke Desktop Launcher

[![Version](https://img.shields.io/badge/version-1.0.0-blue)](https://github.com/Dukeabaddon/duke-toolbox-suite/releases)
[![Platform](https://img.shields.io/badge/platform-Windows%2010%2B-brightgreen)]()
[![License: MIT](https://img.shields.io/badge/license-MIT-green)](LICENSE)
[![Status: Production Ready](https://img.shields.io/badge/status-production%20ready-success)]()

Clone and run (quick):

```bash
git clone https://github.com/Dukeabaddon/duke-toolbox-suite.git
cd duke-toolbox-suite
.
``` 

<p align="center">
	<img src="assets/duke-hero.gif" alt="Duke demo" width="800" />
</p>

Short description
-----------------

Duke is a fast, modular Windows desktop launcher and utilities hub written in pure batch scripts. It provides a clean terminal UI with built-in tools: system report, desktop app launcher, weather, quick links, quotes, small games (Matrix/Tetris), and system diagnostics.

Key features
------------
- Desktop integration: auto-scan `.exe` and `.lnk` items, browser quick-links.
- Utilities: weather (via curl/wttr.in), random quotes, matrix animation, small games.
- System tools: health checks (SFC/DISM), network diagnostics, power & disk reports.
- Customizable: ANSI color schemes, ASCII banner, modular `modules/` layout.
- Zero external deps (except `curl` for network features).

Quick start
-----------
1. Download or clone the repo.
2. Double-click `duke.cmd` or run it from a terminal.

Configuration
-------------
- `config/system-info.txt` — basic system metadata.
- `config/*-links.txt` — browser quick links (pipe-delimited: Title|URL).
- `config/weather-location.txt` — location name for weather lookups.

Contributing
------------
Contributions welcome. Good first steps:

- Open issues for bugs or feature requests.
- Add small, focused PRs in `modules/` with tests if possible.

What to show/screenshots
------------------------
- Add a hero GIF (3–6s) showing the launcher start and a few features (menu, weather, a quick link).
- Include a short annotated screenshot for the two-column menu.

Why this README
----------------
This one-page README focuses on clarity and first-run experience: what Duke is, how to try it immediately, and where to look for customization. For deeper docs keep `documentation/` as-is and link from here.

License
-------
MIT — see `LICENSE`.

Contact
-------
Open issues or mention @Aaron on GitHub.

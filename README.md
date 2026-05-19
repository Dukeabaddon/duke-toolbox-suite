# Duke Desktop Launcher

[![Version](https://img.shields.io/badge/version-1.0.0-blue)](https://github.com/Dukeabaddon/duke-toolbox-suite/releases)
[![Platform](https://img.shields.io/badge/platform-Windows%2010%2B-brightgreen)]()
[![License: MIT](https://img.shields.io/badge/license-MIT-green)](LICENSE)
[![Status: Production Ready](https://img.shields.io/badge/status-production%20ready-success)]()

A fast, modular Windows launcher and utilities hub written in pure batch. Duke gives you a polished terminal UI for launching apps, checking system health, opening quick links, and running lightweight tools from one place.

<p align="center">
	<img src="assets/duke-hero.gif" alt="Duke demo" width="800" />
</p>

## Quick Start

```bash
git clone https://github.com/Dukeabaddon/duke-toolbox-suite.git
cd duke-toolbox-suite
duke.cmd
```

## What It Does

- Launches desktop apps from a clean menu.
- Scans browser links and local shortcuts.
- Shows weather, quotes, and small visual extras.
- Runs system checks, network diagnostics, and power or disk reports.
- Keeps everything modular in `modules/` and easy to customize in `config/`.

## Requirements

- Windows 10 or later.
- PowerShell or Command Prompt.
- `curl` for weather-related features.

## Customize

- `config/system-info.txt` for machine details shown in the UI.
- `config/*-links.txt` for quick-launch browser links in `Title|URL` format.
- `config/weather-location.txt` for the weather lookup location.

Example quick-link entry:

```text
GitHub|https://github.com
Docs|https://learn.microsoft.com
```

## Troubleshooting

- If colors look wrong, use Windows Terminal or enable ANSI support.
- If weather fails, check that `curl` works and the location file is set.
- If a shortcut does not appear, verify the file path and extension in `config/`.

## Contributing

Small, focused PRs are welcome. Start with bug fixes, launcher entries, or config improvements.

## License

MIT. See [LICENSE](LICENSE).

## Contact

Open an issue or mention @Aaron on GitHub.

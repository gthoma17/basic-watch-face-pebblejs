# GitHub Copilot Instructions for Basic Watch Face

## Project Overview

This repository contains a simple, elegant watch face application built with the Pebble SDK. The app displays the current time in a large, centered font with automatic 12-hour or 24-hour format based on system settings.

## Technology Stack

- **Pebble SDK 3**: Classic Pebble smartwatch development platform
- **C**: Primary programming language
- **Python 3**: Build tooling (Pebble SDK)
- **GitHub Actions**: CI/CD pipeline

## Project Structure

```
basic-watch-face-pebblejs/
├── src/
│   └── c/
│       └── main.c           # Main watch face C implementation
├── resources/               # (Optional) Images, fonts, etc.
├── .github/
│   └── workflows/
│       └── ci.yml          # CI/CD pipeline configuration
├── appinfo.json            # App metadata and configuration
├── wscript                 # Build configuration
├── package.json            # Node.js package configuration (for CI)
└── README.md              # Project documentation
```

## Development Commands

### Build Application
```bash
pebble build
```

Builds the watchface for all supported platforms (aplite, basalt, chalk, diorite).

To build for a specific platform:
```bash
pebble build --platform diorite  # Pebble 2
```

### Clean Build
```bash
pebble clean
```

### Install to Device/Emulator
```bash
pebble install --emulator basalt
pebble install --cloudpebble  # Recommended for physical devices
pebble install --phone <PHONE_IP>
```

**Note**: Building requires the Pebble SDK to be installed. Full instructions at [developer.repebble.com/sdk](https://developer.repebble.com/sdk/).

Quick install:
```bash
# Install uv (fast Python package manager)
curl -LsSf https://astral.sh/uv/install.sh | sh

# Install Pebble CLI
uv tool install pebble-tool

# Install SDK
pebble sdk install latest
```

## Code Style and Conventions

1. **C Style**:
   - Follow existing code patterns in the repository
   - Use consistent indentation (2 spaces)
   - Use descriptive variable names with prefixes (s_ for static, g_ for global)
   - Follow Pebble SDK naming conventions

2. **Pebble SDK Patterns**:
   - Use `PBL_IF_ROUND_ELSE` macro for round vs rectangular screens
   - Properly manage memory (create/destroy pairs)
   - Subscribe/unsubscribe from services properly
   - Use system fonts when possible

3. **Documentation**:
   - Update README.md when adding new features
   - Include comments for complex logic
   - Keep appinfo.json version in sync with releases

## Common Development Workflows

### Adding a New Feature
1. Implement the feature in `src/c/main.c` or create new files
2. Update `wscript` if adding new source files
3. Test with `pebble build && pebble install --emulator basalt`
4. Update README.md if user-facing changes are made
5. Update appinfo.json version if releasing

### Fixing a Bug
1. Reproduce the bug locally
2. Fix the bug in the source code
3. Test the fix on emulator or device
4. Ensure no regressions with other features

### Customization
- **Fonts**: Change system font keys (e.g., `FONT_KEY_BITHAM_42_BOLD`)
- **Colors**: Use GColor constants (e.g., `GColorWhite`, `GColorBlack`)
- **Layout**: Adjust GRect coordinates for positioning
- **Update Rate**: Change TickTimerService subscription (MINUTE_UNIT, SECOND_UNIT)

## CI/CD Pipeline

The GitHub Actions workflow (`.github/workflows/ci.yml`) runs on:
- All pushes to `main`/`master`
- All pull requests
- Version tags (format: `v*`)

Pipeline stages:
1. **Build**: Compiles Pebble watchface and creates .pbw artifact
2. **Release**: Creates GitHub releases for version tags with .pbw file

## Important Notes

1. **Pebble SDK Specifics**:
   - Uses modern `uv` tool for fast installation (not pip/virtualenv)
   - SDK available at [developer.repebble.com/sdk](https://developer.repebble.com/sdk/)
   - The SDK is not included in the repository
   - Local development requires Pebble SDK installation
   - CI pipeline installs SDK automatically using `uv tool install pebble-tool`

2. **Platform Support**:
   - **aplite**: Original Pebble (black & white)
   - **basalt**: Pebble Time (color)
   - **chalk**: Pebble Time Round (circular)
   - **diorite**: Pebble 2 (black & white, primary target)

3. **Time Formatting**:
   - Uses `clock_is_24h_style()` to respect system preference
   - Handles both 12-hour and 24-hour formats automatically
   - Updates every minute via TickTimerService

4. **Resource Management**:
   - Always pair create/destroy calls (windows, layers, etc.)
   - Use static variables for persistent data
   - Clean up in deinit() function

5. **Installation Methods**:
   - **CloudPebble**: `pebble install --cloudpebble` (recommended)
   - **Emulator**: `pebble install --emulator basalt`
   - **Direct IP**: `pebble install --phone <IP>`

## Minimal Changes Philosophy

When making changes to this repository:
- Make the smallest possible modifications to achieve the goal
- Preserve working code
- Don't refactor unrelated code
- Focus on surgical, precise changes
- Validate changes don't break existing functionality

## Build Requirements

Before submitting changes:
1. Ensure code compiles with `pebble build`
2. Test on emulator or device
3. Check that CI pipeline will succeed
4. Update version in appinfo.json for releases

## Getting Help

- Review the [Pebble SDK documentation](https://developer.repebble.com/sdk/)
- Check [Rebble](https://rebble.io/) for community support
- Refer to README.md for setup instructions
- Look at CI workflow for build requirements

## File Descriptions

- **appinfo.json**: App metadata (name, UUID, version, platforms)
- **wscript**: Build configuration for Pebble SDK
- **src/c/main.c**: Main watchface implementation
- **resources/**: Optional directory for custom fonts, images, etc.


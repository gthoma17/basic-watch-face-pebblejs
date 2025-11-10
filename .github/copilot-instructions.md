# GitHub Copilot Instructions for Basic Watch Face

## Project Overview

This repository contains a simple, elegant watch face built for Pebble 2 (Diorite) using Pebble SDK 3. The watchface displays the current time in a large, centered font and automatically uses the system's 12-hour or 24-hour format preference.

## Technology Stack

- **Pebble SDK 3**: Official SDK for Pebble smartwatch development
- **C**: Primary programming language for native Pebble apps
- **Python 2.7**: Required by Pebble SDK build tools
- **Waf**: Build system used by Pebble SDK
- **GitHub Actions**: CI/CD pipeline

## Project Structure

```
basic-watch-face-pebblejs/
├── src/
│   └── c/
│       └── main.c       # Main watchface implementation in C
├── resources/           # Resources directory (fonts, images)
├── .github/
│   └── workflows/
│       └── ci.yml      # CI/CD pipeline configuration
├── package.json        # Pebble project metadata (SDK 3 format)
├── wscript            # Build configuration for Waf
└── README.md          # Project documentation
```

## Development Commands

### Install Pebble SDK
```bash
# Install dependencies (Ubuntu/Debian)
sudo apt-get install python2.7 python-pip python-virtualenv

# Create virtual environment
virtualenv --python=python2.7 ~/.pebble-sdk
source ~/.pebble-sdk/bin/activate

# Install Pebble tool
pip install pebble-tool

# Download and install SDK
pebble sdk install latest
```

### Build Watchface
```bash
pebble build
```
Builds the watchface for all target platforms (Aplite, Basalt, Chalk, Diorite) and creates a `.pbw` file in the `build/` directory.

### Test in Emulator
```bash
# For Diorite (Pebble 2) - primary target
pebble install --emulator diorite

# For other platforms
pebble install --emulator basalt   # Pebble Time
pebble install --emulator aplite   # Original Pebble
pebble install --emulator chalk    # Pebble Time Round
```

### Install on Real Device
```bash
pebble install --phone <PEBBLE_IP_ADDRESS>
```

**Note**: Requires Developer Mode enabled on the Pebble watch and both devices on the same network.

## Code Style and Conventions

1. **C Style**:
   - Follow Pebble SDK conventions
   - Use snake_case for function and variable names
   - Use s_ prefix for static variables
   - Keep code simple and efficient for embedded device

2. **Resource Naming**:
   - Use UPPER_CASE for resource identifiers
   - Font resources: FONT_NAME_SIZE format
   - Bitmap resources: descriptive names like BACKGROUND_IMAGE

3. **Documentation**:
   - Update README.md when adding new features
   - Include inline comments for complex logic
   - Keep package.json metadata current

## Pebble SDK Specifics

### package.json Structure

The package.json file contains Pebble-specific metadata in the "pebble" section:

```json
{
  "pebble": {
    "sdkVersion": "3.0",
    "projectType": "native",
    "watchapp": {
      "watchface": true
    },
    "uuid": "unique-app-identifier",
    "targetPlatforms": ["aplite", "basalt", "chalk", "diorite"],
    "resources": {
      "media": []
    }
  }
}
```

Key fields:
- `watchface: true` - Identifies this as a watchface (not a regular app)
- `uuid` - Unique identifier for the app
- `targetPlatforms` - Supported Pebble models
- `sdkVersion` - Pebble SDK version

### wscript Configuration

The wscript file tells Waf how to build the project:
- Source files are in `src/c/`
- Resources are in `resources/`
- Builds for all target platforms automatically

### C Code Structure

Pebble C applications follow this pattern:
```c
static void init() {
  // Initialize window, layers, services
}

static void deinit() {
  // Clean up resources
}

int main(void) {
  init();
  app_event_loop();  // Blocks until app exits
  deinit();
}
```

Key Pebble APIs used:
- `Window` - Main container
- `TextLayer` - Display text
- `tick_timer_service_subscribe()` - Update every minute
- `clock_is_24h_style()` - System time format preference

## Common Development Workflows

### Adding a New Feature
1. Modify `src/c/main.c`
2. If adding resources, update `resources/` and `package.json`
3. Build: `pebble build`
4. Test: `pebble install --emulator diorite`
5. Update README.md if user-facing changes

### Fixing a Bug
1. Fix the bug in C source
2. Build and test locally
3. Verify on multiple platforms if applicable

### Adding Resources
1. Add files to `resources/` directory
2. Update `package.json` "pebble.resources.media" section
3. Reference in C code with generated resource IDs

## CI/CD Pipeline

The GitHub Actions workflow (`.github/workflows/ci.yml`) runs on:
- All pushes to `main`/`master`
- All pull requests
- Version tags (format: `v*`)

Pipeline stages:
1. **Build**: Compiles Pebble watchface for all platforms using Pebble SDK
2. **Release**: Creates GitHub releases for version tags with `.pbw` artifact

## Important Notes

1. **Platform Support**:
   - Primary target: Pebble 2 (Diorite) / Pebble OS v4.9.76
   - Also supports: Aplite, Basalt, Chalk
   - Built with Pebble SDK 3.x

2. **Time Format**:
   - Uses system preference via `clock_is_24h_style()`
   - No separate settings UI needed
   - Updates every minute via `tick_timer_service_subscribe()`

3. **Build System**:
   - Uses Waf (via Pebble SDK)
   - Requires Python 2.7
   - Output: `.pbw` file (Pebble Watch Bundle)

4. **No JavaScript**:
   - This is a pure C native watchface
   - No PebbleJS or JavaScript components
   - Better performance and battery life

## Minimal Changes Philosophy

When making changes to this repository:
- Make the smallest possible modifications to achieve the goal
- Preserve working code
- Focus on surgical, precise changes
- Test on emulator before committing

## Getting Help

- Review the [Pebble SDK documentation](https://developer.rebble.io/)
- Check existing C code structure for examples
- Refer to README.md for setup instructions
- Look at CI workflow for build requirements

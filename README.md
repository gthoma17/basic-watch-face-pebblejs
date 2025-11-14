# Basic Watch Face

A simple, elegant watch face for Pebble smartwatches. Displays the current time in a large, centered font with automatic 12-hour or 24-hour format based on system settings.

## Features

- **Clean Design**: Time displayed in large, bold font centered on the screen
- **Automatic Format**: Respects system 12-hour/24-hour time preference
- **Universal Compatibility**: Works on all Pebble platforms (Aplite, Basalt, Chalk, Diorite)
- **Lightweight**: Minimal resource usage, efficient C implementation
- **Classic Pebble SDK 3**: Built with the standard Pebble SDK

## Target Device

This watchface is optimized for Pebble 2 (diorite platform) running Pebble OS v4.9.76, but is compatible with all Pebble watches.

## Screenshots

The watch face displays the current time in the center of the screen with a clean, minimalist design.

## Development

### Prerequisites

- Pebble SDK 3 or later (Python 3 version recommended)
- Git
- A Pebble device or emulator

### Setting up Pebble SDK

**Option 1: Using Cloud IDE (Easiest)**

The easiest way to start building is with the [Cloud IDE](https://developer.repebble.com/ide/) - no installation required! It runs entirely in your browser.

**Option 2: Local Installation (Recommended for Development)**

Full instructions are available at [developer.repebble.com/sdk](https://developer.repebble.com/sdk/).

**Ubuntu/Debian:**
```bash
# Install dependencies
sudo apt install python3-pip python3-venv nodejs npm libsdl1.2debian libfdt1

# Install uv (fast Python package manager)
curl -LsSf https://astral.sh/uv/install.sh | sh

# Install Pebble CLI
uv tool install pebble-tool

# Install the latest SDK
pebble sdk install latest
```

**macOS:**
```bash
# Install Python 3.10+ (not the default 3.9)
brew install python

# Install uv
curl -LsSf https://astral.sh/uv/install.sh | sh

# Install Pebble CLI
uv tool install pebble-tool

# Install the latest SDK
pebble sdk install latest
```

**Windows:**
The Pebble SDK does not run on Windows, but you can use WSL. Install Ubuntu in WSL, then follow the Ubuntu instructions above.

### Installation

1. Clone the repository:
```bash
git clone https://github.com/gthoma17/basic-watch-face-pebblejs.git
cd basic-watch-face-pebblejs
```

2. Install the Pebble SDK (if not already installed - see above)

### Building

To build the watchface:
```bash
pebble build
```

This will create a `.pbw` file in the `build/` directory that can be sideloaded to your Pebble watch.

To build for a specific platform:
```bash
pebble build --platform diorite  # Pebble 2
pebble build --platform basalt   # Pebble Time
pebble build --platform chalk    # Pebble Time Round
pebble build --platform aplite   # Original Pebble
```

### Installing to Device

**To Emulator:**
```bash
pebble install --emulator basalt
```

**To Physical Device (via CloudPebble):**

Requires the new Pebble mobile app (install at [rePebble.com/app](https://www.repebble.com/app)):
1. Open the Pebble app on your phone
2. Go to Devices → tap 3 dots → Enable Dev Connect → Sign into GitHub
3. On your computer, run:
```bash
pebble login  # Sign into GitHub
pebble install --cloudpebble
```

**Alternative - Direct IP Installation:**
1. Enable Developer Mode on your Pebble watch
2. Connect your watch to your phone
3. Find your phone's IP address
4. Run:
```bash
pebble install --phone <PHONE_IP_ADDRESS>
```

**Manual Installation:**
1. Build the watchface: `pebble build`
2. Find the `.pbw` file in `build/`
3. Transfer to your phone
4. Open with Pebble app to sideload

### Project Structure

```
basic-watch-face-pebblejs/
├── src/
│   └── c/
│       └── main.c           # Main watch face C implementation
├── resources/               # (Optional) Images, fonts, etc.
├── appinfo.json            # App metadata and configuration
├── wscript                 # Build configuration
├── .github/
│   └── workflows/
│       └── ci.yml          # CI/CD pipeline configuration
├── package.json            # Node.js package configuration (for CI)
└── README.md              # This file
```

## How It Works

The watchface is implemented in C using the Pebble SDK:

1. **Time Display**: Uses a `TextLayer` with system font to display time
2. **Updates**: Subscribes to `TickTimerService` to update every minute
3. **Format**: Automatically uses 12-hour or 24-hour format based on system settings via `clock_is_24h_style()`
4. **Compatibility**: Uses `PBL_IF_ROUND_ELSE` macro for round vs rectangular screen layout

## CI/CD Pipeline

The project includes a GitHub Actions workflow that automatically builds and publishes releases:

### Pipeline Jobs

1. **Build**: Creates a `.pbw` (Pebble Watch Bundle) artifact for all supported platforms
2. **Release**: Automatically creates GitHub releases with the `.pbw` artifact when version tags are pushed

### Creating a Release

To create a new release and publish the watch face:

1. Update the version in `appinfo.json`
2. Commit your changes:
   ```bash
   git add .
   git commit -m "Prepare release vX.Y.Z"
   ```

3. Create and push a version tag:
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```

4. The CI/CD pipeline will automatically:
   - Build the watch face for all platforms
   - Create a GitHub release with the tag
   - Attach the `.pbw` file to the release
   - Generate release notes from commits

### Release Artifact

Each release includes a `basic-watch-face.pbw` file that can be:
- Sideloaded directly to a Pebble watch via the mobile app
- Installed using `pebble install --pbw basic-watch-face.pbw`
- Distributed to users for manual installation

## Customization

To customize the watchface, edit `src/c/main.c`:

- **Font**: Change `FONT_KEY_BITHAM_42_BOLD` to another system font
- **Colors**: Modify `GColorWhite` and `GColorBlack` 
- **Position**: Adjust the `GRect` coordinates in `text_layer_create()`
- **Update Frequency**: Change `MINUTE_UNIT` to `SECOND_UNIT` for seconds display

Available system fonts include:
- `FONT_KEY_BITHAM_42_BOLD`
- `FONT_KEY_GOTHIC_28_BOLD`
- `FONT_KEY_ROBOTO_CONDENSED_21`
- And many more in the Pebble SDK documentation

## License

MIT License - feel free to use this project as a starting point for your own watch face applications.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Acknowledgments

- Built with [Pebble SDK 3](https://developer.rebble.io/)
- Supports [Rebble](https://rebble.io/) services for Pebble devices
- Inspired by the need for simple, reliable watch faces

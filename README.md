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

**Option 1: Using pebble-tool (Recommended - Python 3)**

The community maintains a Python 3 compatible version of the Pebble tools:

```bash
# Install dependencies (Ubuntu/Debian)
sudo apt-get install python3-pip python3-dev python3-virtualenv

# Create and activate virtual environment
python3 -m venv ~/.pebble-sdk
source ~/.pebble-sdk/bin/activate

# Install pebble-tool (not pebble-sdk)
pip3 install pebble-tool

# Verify installation
pebble --version
```

**Important Note**: Due to Pebble's shutdown, the official SDK download servers (sdk.core.store) are no longer operational. To complete the SDK setup, you'll need to obtain the SDK core files through alternative means:

1. **Use a local SDK installation** if you have one from before Pebble's shutdown
2. **Use RebbleOS SDK** - Check [Rebble's developer resources](https://developer.rebble.io/)
3. **Find community mirrors** of the SDK core files

**Option 2: Docker-based Pebble SDK**

You can use a Docker container with a pre-configured Pebble SDK:

```bash
# Pull a community Pebble SDK Docker image
docker pull pebble/sdk

# Build from within the container
docker run --rm -v "$(pwd):/pebble" pebble/sdk pebble build
```

### Installation

1. Clone the repository:
```bash
git clone https://github.com/gthoma17/basic-watch-face-pebblejs.git
cd basic-watch-face-pebblejs
```

2. Ensure Pebble SDK is activated:
```bash
source ~/.pebble-sdk/bin/activate  # if using virtualenv
```

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

**To Physical Device:**
1. Enable Developer Mode on your Pebble watch
2. Connect your watch to your phone
3. Run:
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

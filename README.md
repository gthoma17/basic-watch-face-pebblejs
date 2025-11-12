# Basic Watch Face

A simple, elegant watch face for Pebble 2 (Diorite) built with Pebble SDK 3. Displays the current time in a large, centered font and automatically uses the system's 12-hour or 24-hour format preference.

## Features

- **Clean Design**: Time displayed in large, bold font centered on the screen
- **System Format**: Automatically uses your Pebble's 12-hour or 24-hour time setting
- **Multi-Platform Support**: Compatible with Aplite, Basalt, Chalk, and Diorite
- **Lightweight**: Minimal resource usage for better battery life
- **Native Performance**: Built in C for optimal speed and efficiency

## Screenshots

The watch face displays the current time in the center of the screen with a clean, minimalist design on a white background.

## Installation

### For Users

1. Download the latest `.pbw` file from the [Releases](https://github.com/gthoma17/basic-watch-face-pebblejs/releases) page
2. Open the file on your phone with the Pebble app installed
3. The watchface will be automatically transferred to your Pebble watch
4. Select the watchface from the Pebble app's watchface selection screen

### For Developers

See the Development section below.

## Development

### Prerequisites

- Pebble SDK 3.x or higher
- Python 3.7+ (required by modern pebble-tool)
- Git

### Setting Up the Pebble SDK

Follow the official guide to install the Pebble SDK:
- [Pebble SDK Installation Guide](https://developer.rebble.io/sdk/)

For quick setup on Linux/macOS:
```bash
# Install SDK dependencies
sudo apt-get install python3 python3-pip python3-venv

# Create a virtual environment and install Pebble tool
python3 -m venv ~/.pebble-sdk
source ~/.pebble-sdk/bin/activate
pip install pebble-tool

# Download and install the SDK
pebble sdk install latest
```

### Building

1. Clone the repository:
```bash
git clone https://github.com/gthoma17/basic-watch-face-pebblejs.git
cd basic-watch-face-pebblejs
```

2. Build the project:
```bash
pebble build
```

This will create a `.pbw` file in the `build/` directory.

### Testing

#### In the Emulator

To test in the Pebble emulator:
```bash
# For Basalt (Pebble Time)
pebble install --emulator basalt

# For Diorite (Pebble 2)
pebble install --emulator diorite

# For Aplite (Original Pebble)
pebble install --emulator aplite

# For Chalk (Pebble Time Round)
pebble install --emulator chalk
```

#### On a Real Device

1. Make sure your phone and development machine are on the same network
2. Enable Developer Mode on your Pebble (Settings → System → Developer Mode)
3. Note your Pebble's IP address
4. Install to your watch:
```bash
pebble install --phone <PEBBLE_IP_ADDRESS>
```

### Project Structure

```
basic-watch-face-pebblejs/
├── src/
│   └── c/
│       └── main.c          # Main watchface implementation in C
├── resources/               # Resources directory (fonts, images)
├── .github/
│   └── workflows/
│       └── ci.yml          # CI/CD pipeline configuration
├── package.json            # Pebble project metadata
├── wscript                 # Build configuration
└── README.md              # This file
```

## Configuration

The watchface automatically respects your Pebble's system time format setting:
- To change between 12-hour and 24-hour format, adjust it in your Pebble's system settings
- The watchface will immediately reflect the change

## CI/CD Pipeline

The project includes a GitHub Actions workflow that automatically builds the watchface:

### Pipeline Jobs

1. **Build**: Compiles the watchface for all supported platforms
2. **Release**: Automatically creates GitHub releases with the `.pbw` file when version tags are pushed

### Creating a Release

To create a new release:

1. Update the version in `package.json`
2. Commit your changes:
   ```bash
   git add .
   git commit -m "Prepare release vX.Y.Z"
   ```

3. Create and push a version tag:
   ```bash
   git tag vX.Y.Z
   git push origin vX.Y.Z
   ```

4. The CI/CD pipeline will automatically:
   - Build the watchface for all platforms
   - Create a GitHub release with the tag
   - Attach the `.pbw` file to the release
   - Generate release notes from commits

## Technical Details

- **SDK Version**: Pebble SDK 3.0
- **Language**: C
- **Target Platforms**: Aplite, Basalt, Chalk, Diorite
- **Primary Target**: Pebble 2 (Diorite) / Pebble OS v4.9.76
- **Update Frequency**: Every minute
- **Font**: System font (Bitham 42 Bold)

## License

MIT License - feel free to use this project as a starting point for your own watch face applications.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Acknowledgments

- Built with [Pebble SDK](https://developer.rebble.io/)
- Maintained by the Rebble community
- Inspired by the need for simple, reliable watchfaces
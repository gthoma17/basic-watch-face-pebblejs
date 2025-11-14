#!/bin/bash

# Build script for Pebble SDK watchface
# Creates .pbw (Pebble Watch Bundle) using Pebble SDK

set -e

VERSION=${1:-"1.0.0"}
APP_NAME="basic-watch-face"
BUILD_DIR="build"

echo "Building Pebble watchface ${APP_NAME} version ${VERSION}..."

# Check if pebble command is available
if ! command -v pebble &> /dev/null; then
    echo "Error: Pebble SDK not found in PATH"
    echo ""
    echo "To install the Pebble SDK, visit: https://developer.repebble.com/sdk/"
    echo ""
    echo "Quick install:"
    echo "  curl -LsSf https://astral.sh/uv/install.sh | sh"
    echo "  uv tool install pebble-tool"
    echo "  pebble sdk install latest"
    exit 1
fi

# Check if SDK is installed
if ! pebble sdk list 2>&1 | grep -q "SDK"; then
    echo "Warning: Pebble SDK core not detected"
    echo "Installing latest SDK..."
    pebble sdk install latest || {
        echo "SDK installation failed."
        echo "Please visit https://developer.repebble.com/sdk/ for installation instructions."
        exit 1
    }
fi

# Clean any previous builds
echo "Cleaning previous builds..."
pebble clean || true
rm -rf "${BUILD_DIR}"

# Build the watchface for all platforms
echo "Building watchface..."
pebble build

# Check if build was successful
if [ -f "${BUILD_DIR}/${APP_NAME}.pbw" ]; then
    echo "✓ Successfully created ${BUILD_DIR}/${APP_NAME}.pbw"
    echo ""
    echo "Build artifact details:"
    ls -lh "${BUILD_DIR}/${APP_NAME}.pbw"
    echo ""
    echo "Installation options:"
    echo "  - Emulator: pebble install --emulator basalt"
    echo "  - CloudPebble: pebble install --cloudpebble"
    echo "  - Direct IP: pebble install --phone <PHONE_IP>"
else
    echo "✗ Build failed - no .pbw file created"
    exit 1
fi




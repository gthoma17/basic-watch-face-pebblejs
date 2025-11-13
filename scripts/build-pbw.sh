#!/bin/bash

# Build script for Pebble SDK watchface
# Creates .pbw (Pebble Watch Bundle) using Pebble SDK

set -e

VERSION=${1:-"1.0.0"}
APP_NAME="basic-watch-face"
BUILD_DIR="build"

echo "Building Pebble watchface ${APP_NAME} version ${VERSION}..."

# Check if we're in a Pebble SDK environment
if ! command -v pebble &> /dev/null; then
    echo "Warning: Pebble SDK not found in PATH"
    echo "Attempting to install Pebble SDK with Python 3..."
    
    # Create virtual environment if it doesn't exist
    if [ ! -d "$HOME/.pebble-sdk" ]; then
        python3 -m venv "$HOME/.pebble-sdk"
    fi
    
    # Activate virtual environment
    source "$HOME/.pebble-sdk/bin/activate"
    
    # Install Pebble SDK
    pip3 install --upgrade pip setuptools wheel
    pip3 install pebble-sdk
    
    echo "Pebble SDK installed successfully"
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
    echo "To install on device: pebble install --phone <PHONE_IP>"
    echo "To install on emulator: pebble install --emulator basalt"
else
    echo "✗ Build failed - no .pbw file created"
    exit 1
fi


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
    echo "Attempting to install pebble-tool with Python 3..."
    
    # Create virtual environment if it doesn't exist
    if [ ! -d "$HOME/.pebble-sdk" ]; then
        python3 -m venv "$HOME/.pebble-sdk"
    fi
    
    # Activate virtual environment
    source "$HOME/.pebble-sdk/bin/activate"
    
    # Install pebble-tool
    pip3 install --upgrade pip setuptools wheel
    pip3 install pebble-tool
    
    echo "pebble-tool installed successfully"
fi

# Ensure we're using the virtual environment
if [ -d "$HOME/.pebble-sdk/bin" ]; then
    source "$HOME/.pebble-sdk/bin/activate"
fi

# Check if SDK is installed
if ! pebble sdk list 2>&1 | grep -q "4."; then
    echo "Warning: Pebble SDK core not installed"
    echo "Attempting to install SDK..."
    pebble sdk install latest || {
        echo "SDK installation failed. This is expected if Pebble servers are unavailable."
        echo ""
        echo "To build this watchface, you need a fully configured Pebble SDK environment."
        echo "Please see README.md for alternative SDK installation methods."
        echo ""
        echo "The project structure is valid and ready for development once the SDK is installed."
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
    echo "To install on device: pebble install --phone <PHONE_IP>"
    echo "To install on emulator: pebble install --emulator basalt"
else
    echo "✗ Build failed - no .pbw file created"
    exit 1
fi



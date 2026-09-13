#!/usr/bin/env bash

set -e

ENV_FILE=".env"

if [ ! -f "$ENV_FILE" ]; then
    echo "Error: .env file not found."
    echo "add .env file to project root directory."
    exit 1
fi

set -a
source "$ENV_FILE"
set +a

# Defaults
BUILD_DIR="${BUILD_DIR:-build}"
INSTALL_DIR="${INSTALL_DIR:-dist}"
BUILD_TYPE="${BUILD_TYPE:-Release}"
BUILD_TESTING="${BUILD_TESTING:-OFF}"
CMAKE_GENERATOR="${CMAKE_GENERATOR:-Ninja}"

echo "================================"
echo "        Scripto Build"
echo "================================"
echo "Qt:         $QT_DIR"
echo "Generator:  $CMAKE_GENERATOR"
echo "Build Type: $BUILD_TYPE"
echo "Tests:      $BUILD_TESTING"
echo 

if [ -z "$QT_DIR" ]; then
    echo "Error: QT_DIR is not set in .env file."
    exit 1
fi

if [ ! -d "$QT_DIR" ]; then
    echo "Error: Qt directory does not exist."
    echo "$QT_DIR"
    exit 1
fi

echo "Configuring..."

cmake -S . -B "$BUILD_DIR" \
    -G "$CMAKE_GENERATOR" \
    -DCMAKE_BUILD_TYPE="$BUILD_TYPE" \
    -DCMAKE_PREFIX_PATH="$QT_DIR" \
    -DBUILD_TESTING="$BUILD_TESTING" \
    -Wno-author

echo
echo "Building..."

cmake --build "$BUILD_DIR"

echo
echo "Installing..."

rm -rf "$INSTALL_DIR"

cmake --install "$BUILD_DIR" --prefix "$PWD/$INSTALL_DIR"

echo
echo "================================"
echo "Build completed successfully!"
echo "Output: $PWD/$INSTALL_DIR"
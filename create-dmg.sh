#!/bin/bash

# Build the macOS app first
echo "Building macOS app..."
flutter build macos --release

# Check if the app was built successfully
if [ ! -d "build/macos/Build/Products/Release/Trackich.app" ]; then
    echo "Error: Trackich.app not found. Build failed."
    exit 1
fi

# Create clean temp directory
echo "Creating temp directory..."
mkdir -p /tmp/trackich_clean
cp -R "build/macos/Build/Products/Release/Trackich.app" /tmp/trackich_clean/

# Create DMG using create-dmg tool
echo "Creating DMG..."
create-dmg \
  --volname "Trackich" \
  --window-pos 200 120 \
  --window-size 600 400 \
  --icon-size 100 \
  --icon "Trackich.app" 150 200 \
  --hide-extension "Trackich.app" \
  --app-drop-link 450 200 \
  "Trackich.dmg" \
  "/tmp/trackich_clean/"

# Cleanup
echo "Cleaning up..."
rm -rf /tmp/trackich_clean

echo "DMG created successfully: Trackich.dmg"
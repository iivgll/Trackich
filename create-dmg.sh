#!/bin/bash

# Configuration
APP_NAME="Trackich"
APP_FILE="trackich.app"
DMG_NAME="${APP_NAME}.dmg"
BUILD_DIR="build/macos/Build/Products/Release"
VOLUME_NAME="${APP_NAME}"
ICON_SIZE=100
DMG_WIDTH=600
DMG_HEIGHT=400

# Clean up any existing DMG
rm -f "${DMG_NAME}"

# Create temporary DMG
echo "Creating temporary DMG..."
hdiutil create -size 200m -fs HFS+ -volname "${VOLUME_NAME}" "temp.dmg"

# Mount the temporary DMG
echo "Mounting temporary DMG..."
MOUNT_POINT=$(hdiutil attach "temp.dmg" | tail -1 | cut -d' ' -f3-)

# Create temporary clean directory and copy only the app
echo "Preparing clean app file..."
TEMP_DIR="/tmp/trackich_dmg_temp"
mkdir -p "${TEMP_DIR}"
cp -R "${BUILD_DIR}/${APP_FILE}" "${TEMP_DIR}/"

# Copy app to DMG
echo "Copying app to DMG..."
cp -R "${TEMP_DIR}/${APP_FILE}" "${MOUNT_POINT}/"

# Create Applications link
echo "Creating Applications link..."
ln -s /Applications "${MOUNT_POINT}/Applications"

# Set up DMG appearance
echo "Setting up DMG appearance..."
osascript <<EOF
tell application "Finder"
    tell disk "${VOLUME_NAME}"
        open
        set current view of container window to icon view
        set toolbar visible of container window to false
        set statusbar visible of container window to false
        set the bounds of container window to {100, 100, $((100 + DMG_WIDTH)), $((100 + DMG_HEIGHT))}
        set viewOptions to the icon view options of container window
        set arrangement of viewOptions to not arranged
        set icon size of viewOptions to ${ICON_SIZE}
        set position of item "${APP_FILE}" of container window to {150, 200}
        set position of item "Applications" of container window to {450, 200}
        close
        open
        update without registering applications
        delay 2
    end tell
end tell
EOF

# Unmount the temporary DMG
echo "Unmounting temporary DMG..."
hdiutil detach "${MOUNT_POINT}"

# Convert to compressed DMG
echo "Converting to compressed DMG..."
hdiutil convert "temp.dmg" -format UDZO -o "${DMG_NAME}"

# Clean up
rm -f "temp.dmg"
rm -rf "${TEMP_DIR}"

echo "DMG created successfully: ${DMG_NAME}"

# Show file info
ls -la "${DMG_NAME}"
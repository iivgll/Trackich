#!/bin/bash

echo "Building Linux version using Docker..."

# Build Docker image
docker build -f Dockerfile.linux -t trackich-linux-builder .

# Create output directory
mkdir -p dist/linux

# Run container and copy output
docker run --rm -v $(pwd)/dist/linux:/output trackich-linux-builder

echo "Linux build completed! Output in: dist/linux/"
echo "To package as AppImage or .deb, run additional packaging scripts."
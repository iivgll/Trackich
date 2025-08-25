#!/bin/bash

echo "Building Windows version using Docker..."
echo "Note: This requires Docker Desktop with Windows containers enabled"

# Build Docker image (requires Windows containers)
docker build -f Dockerfile.windows -t trackich-windows-builder .

# Create output directory
mkdir -p dist/windows

# Run container and copy output
docker run --rm -v $(pwd)/dist/windows:/output trackich-windows-builder

echo "Windows build completed! Output in: dist/windows/"
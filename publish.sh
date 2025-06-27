#!/bin/bash

# Publish script for OCR File Converter
# Builds and pushes multi-platform Docker images to Docker Hub

set -e

# Configuration
DOCKER_USERNAME="truongginjs"
IMAGE_NAME="ocr-converter"
VERSION="1.1"

echo "🚀 OCR File Converter - Docker Hub Publisher"
echo "============================================="
echo "📦 Image: ${DOCKER_USERNAME}/${IMAGE_NAME}"
echo "🏷️  Version: ${VERSION}"
echo "🎯 Platforms: linux/arm64, linux/amd64"
echo ""

# Check if logged in to Docker Hub
if ! docker info | grep -q "Username: ${DOCKER_USERNAME}"; then
    echo "⚠️  Please login to Docker Hub first:"
    echo "   docker login"
    exit 1
fi

echo "✅ Docker Hub login verified"

# Check if buildx is available
if ! docker buildx version > /dev/null 2>&1; then
    echo "❌ Docker buildx not available. Please update Docker to latest version."
    echo "   See: https://docs.docker.com/buildx/working-with-buildx/"
    exit 1
fi

# Create/use multiplatform builder
echo "🔧 Setting up multi-platform builder..."
docker buildx create --name multiplatform-builder --use --bootstrap 2>/dev/null || true
docker buildx use multiplatform-builder

# Verify platforms are available
echo "🔍 Checking available platforms..."
docker buildx inspect --bootstrap

echo ""
echo "🏗️  Building multi-platform images..."
echo "⏳ This may take several minutes..."

# Build and push multi-platform images
docker buildx build --platform linux/arm64,linux/amd64 \
    -t ${DOCKER_USERNAME}/${IMAGE_NAME}:${VERSION} \
    -t ${DOCKER_USERNAME}/${IMAGE_NAME}:latest \
    --push .

echo ""
echo "✅ Successfully published to Docker Hub!"
echo ""
echo "📋 Published images:"
echo "  • ${DOCKER_USERNAME}/${IMAGE_NAME}:${VERSION}"
echo "  • ${DOCKER_USERNAME}/${IMAGE_NAME}:latest"
echo ""
echo "🎯 Both images support:"
echo "  • linux/arm64 (Apple Silicon, ARM processors)"
echo "  • linux/amd64 (Intel/AMD processors)"
echo ""
echo "🚀 Usage examples:"
echo ""
echo "Pull and run:"
echo "  docker pull ${DOCKER_USERNAME}/${IMAGE_NAME}:latest"
echo "  docker run -p 8000:8000 ${DOCKER_USERNAME}/${IMAGE_NAME}:latest"
echo ""
echo "Use with docker-compose:"
echo "  docker-compose up document-converter"
echo ""
echo "📖 View on Docker Hub:"
echo "   https://hub.docker.com/r/${DOCKER_USERNAME}/${IMAGE_NAME}"

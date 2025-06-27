#!/bin/bash

# Build script for Multi-Platform Architecture - OCR File Converter
# Builds for both ARM64 (Apple Silicon) and AMD64 (Intel/AMD) architectures

set -e

echo "🏗️  Building OCR File Converter for Multi-Platform..."
echo "🎯 Target Platforms: linux/arm64, linux/amd64"
echo "📦 Features: English + Vietnamese language support"
echo ""

# Check if buildx is available
if ! docker buildx version > /dev/null 2>&1; then
    echo "❌ Docker buildx not available. Please update Docker to latest version."
    exit 1
fi

# Create/use multiplatform builder
echo "🔧 Setting up multi-platform builder..."
docker buildx create --name multiplatform-builder --use --bootstrap 2>/dev/null || true
docker buildx use multiplatform-builder

# Build and push multi-platform images
echo "🚀 Building and pushing version 1.1..."
docker buildx build --platform linux/arm64,linux/amd64 \
    -t truongginjs/ocr-converter:1.1 \
    -t truongginjs/ocr-converter:latest \
    --push .

echo "✅ Multi-platform build completed successfully!"
echo ""
echo "📋 Built for platforms:"
echo "  • linux/arm64 (Apple Silicon, ARM processors)"
echo "  • linux/amd64 (Intel/AMD processors)"
echo ""
echo "🏷️  Tags created:"
echo "  • truongginjs/ocr-converter:1.1"
echo "  • truongginjs/ocr-converter:latest"

echo "✅ Build completed successfully!"
echo ""
echo "🔍 Language support check:"
docker run --rm truongginjs/ocr-converter:latest tesseract --list-langs
echo ""
echo "🚀 Usage examples:"
echo ""
echo "1. Start web service:"
echo "   docker-compose up document-converter"
echo ""
echo "2. Convert files via CLI (English):"
echo "   docker-compose run --rm document-converter-cli /app/input -o /app/output -f json -l eng"
echo ""
echo "3. Convert files via CLI (Vietnamese):"
echo "   docker-compose run --rm document-converter-cli /app/input -o /app/output -f json -l vie"
echo ""
echo "4. Direct Docker usage:"
echo "   docker run --rm -v \$(pwd)/data:/app/input -v \$(pwd)/output:/app/output \\"
echo "     truongginjs/ocr-converter:1.1 python converter.py /app/input/file.pdf -o /app/output"
echo "   docker run --rm -v \$(pwd)/data:/app/input -v \$(pwd)/output:/app/output \\"
echo "     truongginjs/ocr-converter:latest python converter.py /app/input/1.pdf -o /app/output -l eng,vie"
echo ""
echo "🌐 API Documentation: http://localhost:8000/docs (when web service is running)"
echo ""
echo "📤 To push to Docker Hub:"
echo "   docker push truongginjs/ocr-converter:latest"

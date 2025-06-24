#!/bin/bash

# Test script for the OCR File Converter

set -e

echo "🚀 Testing OCR File Converter..."
echo ""

# Ensure output directory exists
mkdir -p output

echo "📦 Building Docker image..."
docker build -t truongginjs/ocr-file:latest .

echo ""
echo "🔍 Checking language support..."
docker run --rm truongginjs/ocr-file:latest tesseract --list-langs

echo ""
echo "🔄 Testing PDF conversion..."

# Test 1: Convert PDF to text (English default)
echo "Test 1: Converting PDF to text format (English)..."
docker run --rm \
  -v $(pwd)/data:/app/input \
  -v $(pwd)/output:/app/output \
  truongginjs/ocr-file:latest \
  python converter.py /app/input/1.pdf -o /app/output -f txt -l eng

# Test 2: Convert PDF to JSON with Vietnamese
echo ""
echo "Test 2: Converting PDF to JSON with Vietnamese language..."
docker run --rm \
  -v $(pwd)/data:/app/input \
  -v $(pwd)/output:/app/output \
  truongginjs/ocr-file:latest \
  python converter.py /app/input/1.pdf -o /app/output -f json -l vie

# Test 3: Convert PDF with multiple languages
echo ""
echo "Test 3: Converting PDF with multiple languages (English + Vietnamese)..."
docker run --rm \
  -v $(pwd)/data:/app/input \
  -v $(pwd)/output:/app/output \
  truongginjs/ocr-file:latest \
  python converter.py /app/input/1.pdf -o /app/output -f json -l eng,vie

echo ""
echo "✅ All conversion tests completed!"
echo ""
echo "📁 Check the output directory for results:"
ls -la output/

echo ""
echo "🌐 To start the web service, run:"
echo "   docker-compose up document-converter"
echo ""
echo "📚 Then visit: http://localhost:8000/docs for API documentation"
echo ""
echo "🌍 Language support:"
echo "   - English (eng) - default"
echo "   - Vietnamese (vie) - new in latest version"

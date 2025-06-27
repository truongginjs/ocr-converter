#!/bin/bash

# Quick deployment script for OCR File Converter

set -e

echo "🚀 OCR File Converter - Quick Deploy"
echo "===================================="
echo ""

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker first."
    exit 1
fi

echo "✅ Docker is running"

# Create necessary directories
echo "📁 Creating directories..."
mkdir -p data output

echo "📦 Pulling OCR File Converter (v1.1 - Multi-Platform)..."
docker pull truongginjs/ocr-converter:latest

echo "✅ Image pulled successfully!"
echo "🎯 Platform: Automatically selected for your architecture"
echo ""

# Show usage options
echo "🎯 Choose deployment option:"
echo ""
echo "1. 🌐 Web API Service (English)"
echo "   docker-compose up document-converter"
echo ""
echo "2. 🇻🇳 Web API Service (Vietnamese)"
echo "   docker-compose --profile vietnamese up document-converter-vie"
echo ""
echo "3. 💻 CLI Processing (English)"
echo "   docker-compose --profile cli run --rm document-converter-cli /app/input -o /app/output -f json -l eng"
echo ""
echo "4. 💻 CLI Processing (Vietnamese)"
echo "   docker-compose --profile cli run --rm document-converter-cli /app/input -o /app/output -f json -l vie"
echo ""
echo "5. 🔄 Direct Docker Run (English)"
echo "   docker run --rm -v \$(pwd)/data:/app/input -v \$(pwd)/output:/app/output truongginjs/ocr-converter:latest python converter.py /app/input -o /app/output -l eng"
echo ""
echo "6. 🔄 Direct Docker Run (Vietnamese)"
echo "   docker run --rm -v \$(pwd)/data:/app/input -v \$(pwd)/output:/app/output truongginjs/ocr-converter:latest python converter.py /app/input -o /app/output -l vie"
echo ""
echo "📋 Instructions:"
echo "• Place your PDF files in the './data' directory"
echo "• Processed files will appear in the './output' directory"
echo "• For web API: visit http://localhost:8000/docs for documentation"
echo "• For Vietnamese API: visit http://localhost:8001/docs for documentation"
echo ""
echo "🌍 Supported Languages:"
echo "• English (eng) - Default"
echo "• Vietnamese (vie) - Latest version"
echo ""
echo "🔧 Language Configuration:"
echo "• Single language: -l eng or -l vie"
echo "• Multiple languages: -l eng,vie"
echo ""

# Ask user what they want to do
echo "❓ What would you like to do?"
echo "1) Start Web API (English) - Port 8000"
echo "2) Start Web API (Vietnamese) - Port 8001"
echo "3) Test conversion with sample file"
echo "4) Exit"
echo ""

read -p "Enter your choice (1-4): " choice

case $choice in
    1)
        echo "🌐 Starting Web API (English) on port 8000..."
        echo "📚 API Documentation: http://localhost:8000/docs"
        docker-compose up document-converter
        ;;
    2)
        echo "🇻🇳 Starting Web API (Vietnamese) on port 8001..."
        echo "📚 API Documentation: http://localhost:8001/docs"
        docker-compose --profile vietnamese up document-converter-vie
        ;;
    3)
        if [ ! -f "data/1.pdf" ]; then
            echo "⚠️  No sample file found. Please place a PDF file named '1.pdf' in the data directory."
            echo "💡 You can also place any PDF file in the data directory for testing."
        else
            echo "🧪 Testing conversion with sample file..."
            docker run --rm -v $(pwd)/data:/app/input -v $(pwd)/output:/app/output \
                truongginjs/ocr-converter:latest python converter.py /app/input/1.pdf -o /app/output -l eng -f json
            echo "✅ Test completed! Check the output directory."
        fi
        ;;
    4)
        echo "👋 Goodbye!"
        exit 0
        ;;
    *)
        echo "❌ Invalid choice. Please run the script again."
        exit 1
        ;;
esac

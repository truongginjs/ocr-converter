# OCR File Converter 📄🔍

A powerful Python-based document converter application that performs Optical Character Recognition (OCR) on PDF documents and images, extracting text content with high accuracy.

## Features

- **Multiple Input Formats**: PDF, JPG, PNG, BMP, TIFF, WEBP
- **Multiple Output Formats**: Plain text (TXT) or structured JSON
- **OCR Engines**: Tesseract and EasyOCR support
- **Multi-language Support**: English and Vietnamese (v0.2+), with easy expansion for more languages
- **Multi-Platform Support**: Compatible with both ARM64 (Apple Silicon) and AMD64 architectures
- **Batch Processing**: Convert multiple files at once
- **REST API**: Web service for programmatic access
- **CLI Interface**: Command-line tool for batch operations
- **Image Preprocessing**: Automatic image enhancement for better OCR accuracy
- **Docker Ready**: Pre-built multi-platform images available on Docker Hub

## Quick Start

### 1. Using Docker Hub (Recommended)

**Pull and run the latest version:**
```bash
# Pull the latest image (multi-platform support)
docker pull truongginjs/ocr-converter:latest

# Or pull a specific version
docker pull truongginjs/ocr-converter:1.1

# Run the container
docker run -d \
  --name ocr-converter \
  -p 8000:8000 \
  -v $(pwd)/input:/app/input \
  -v $(pwd)/output:/app/output \
  truongginjs/ocr-converter:latest
```

**Version History:**
- `1.1` - Multi-platform support (ARM64 & AMD64), improved architecture compatibility
- `0.2` - Added Vietnamese language support
- `latest` - Always points to the most recent stable version

### 2. Build from Source

```bash
docker build -t document-converter .
```

### 3. Using Docker Compose (Local Build)

**Start the web service:**
```bash
docker-compose up document-converter
```

**Use CLI for batch processing:**
```bash
docker-compose run --rm document-converter-cli /app/input -o /app/output -f json
```

### 3. Direct Docker Usage

**Convert files via CLI:**
```bash
# Convert single file (default English)
docker run --rm -v $(pwd)/data:/app/input -v $(pwd)/output:/app/output \
  truongginjs/ocr-converter:latest python converter.py /app/input/1.pdf -o /app/output -f txt

# Convert with Vietnamese language support
docker run --rm -v $(pwd)/data:/app/input -v $(pwd)/output:/app/output \
  truongginjs/ocr-converter:latest python converter.py /app/input/1.pdf -o /app/output -f txt -l vie

# Convert with multiple languages
docker run --rm -v $(pwd)/data:/app/input -v $(pwd)/output:/app/output \
  truongginjs/ocr-converter:latest python converter.py /app/input/1.pdf -o /app/output -f json -l eng,vie

# Convert entire directory
docker run --rm -v $(pwd)/data:/app/input -v $(pwd)/output:/app/output \
  truongginjs/ocr-converter:latest python converter.py /app/input -o /app/output -f json
```

**Run web service:**
```bash
docker run --rm -p 8000:8000 -v $(pwd)/data:/app/input -v $(pwd)/output:/app/output \
  truongginjs/ocr-converter:latest python api.py
```

## Usage Examples

### CLI Usage

```bash
# Basic conversion (English default)
python converter.py input.pdf

# Specify output format and directory
python converter.py input.pdf -o ./output -f json

# Use specific language
python converter.py document.pdf -l vie  # Vietnamese
python converter.py document.pdf -l eng,vie  # English + Vietnamese

# Use EasyOCR engine
python converter.py image.jpg -e easyocr -f txt

# Batch convert directory with language specification
python converter.py ./images/ -o ./output -f json -l eng,vie

# Exclude metadata
python converter.py input.pdf --no-metadata
```

### API Usage

Once the web service is running (http://localhost:8000), you can:

1. **Visit the API documentation**: http://localhost:8000/docs
2. **Upload files via curl**:

```bash
# Convert single file
curl -X POST "http://localhost:8000/convert" \
  -F "files=@data/1.pdf" \
  -F "output_format=json" \
  -F "ocr_engine=tesseract"

# Convert multiple files
curl -X POST "http://localhost:8000/convert" \
  -F "files=@image1.jpg" \
  -F "files=@image2.png" \
  -F "output_format=txt"
```

## Configuration Options

### CLI Arguments

- `input`: Input file or directory path
- `-o, --output`: Output directory (default: ./output)
- `-f, --format`: Output format - txt or json (default: txt)
- `-e, --engine`: OCR engine - tesseract or easyocr (default: tesseract)
- `--no-metadata`: Exclude metadata from output

### API Parameters

- `files`: List of files to upload
- `output_format`: txt or json (default: txt)
- `ocr_engine`: tesseract or easyocr (default: tesseract)
- `include_metadata`: Include extraction metadata (default: true)

## Output Formats

### Text Format (.txt)
Plain text extraction of the document content.

### JSON Format (.json)
Structured output including:
```json
{
  "filename": "document.pdf",
  "file_type": ".pdf",
  "success": true,
  "text": "Extracted text content...",
  "metadata": {
    "extraction_method": "direct",
    "character_count": 1234,
    "word_count": 200,
    "confidence": 95.5
  }
}
```

## Supported File Types

- **PDF**: .pdf
- **Images**: .jpg, .jpeg, .png, .bmp, .tiff, .webp

## Language Support 🌍

### Currently Supported Languages

The OCR File Converter currently supports the following languages:

| Language | Code | Tesseract Package | Status |
|----------|------|------------------|---------|
| English | eng | tesseract-ocr-eng | ✅ Active |
| Vietnamese | vie | tesseract-ocr-vie | ✅ Active |
| French | fra | tesseract-ocr-fra | 🔧 Available (commented) |
| German | deu | tesseract-ocr-deu | 🔧 Available (commented) |
| Spanish | spa | tesseract-ocr-spa | 🔧 Available (commented) |

### Adding More Languages

To add support for additional languages, follow these steps:

#### 1. Check Available Languages
First, check what languages are available for Tesseract:
```bash
# List all available Tesseract language packages
apt-cache search tesseract-ocr-

# Common languages include:
# tesseract-ocr-fra (French)
# tesseract-ocr-deu (German)
# tesseract-ocr-spa (Spanish)
# tesseract-ocr-ita (Italian)
# tesseract-ocr-jpn (Japanese)
# tesseract-ocr-chi-sim (Chinese Simplified)
# tesseract-ocr-chi-tra (Chinese Traditional)
# tesseract-ocr-kor (Korean)
# tesseract-ocr-ara (Arabic)
# tesseract-ocr-rus (Russian)
```

#### 2. Update the Dockerfile
Edit the `Dockerfile` and uncomment or add the desired language packages:

```dockerfile
# Install system dependencies for OCR and PDF processing
RUN apt-get update && apt-get install -y \
    tesseract-ocr \
    tesseract-ocr-eng \
    tesseract-ocr-vie \
    tesseract-ocr-fra \    # Uncomment for French
    tesseract-ocr-deu \    # Uncomment for German
    tesseract-ocr-spa \    # Uncomment for Spanish
    # tesseract-ocr-ita \  # Add for Italian
    # tesseract-ocr-jpn \  # Add for Japanese
    poppler-utils \
    # ... rest of dependencies
```

#### 3. Rebuild the Docker Image
```bash
# Build with a new version tag
docker build -t truongginjs/ocr-converter:0.3 .

# Or build locally
docker build -t document-converter .
```

#### 4. Using Multiple Languages
When using the OCR converter, you can specify language codes:

```bash
# Single language
python converter.py document.pdf -l eng

# Multiple languages (comma-separated)
python converter.py document.pdf -l eng,vie,fra

# Via Docker
docker run --rm -v $(pwd)/data:/app/input -v $(pwd)/output:/app/output \
  truongginjs/ocr-converter:0.2 python converter.py /app/input/document.pdf -l eng,vie
```

### Language Code Reference

For a complete list of language codes, visit: [Tesseract Language Data](https://github.com/tesseract-ocr/tessdata)

Common language codes:
- `eng` - English
- `vie` - Vietnamese  
- `fra` - French
- `deu` - German
- `spa` - Spanish
- `ita` - Italian
- `jpn` - Japanese
- `chi_sim` - Chinese (Simplified)
- `chi_tra` - Chinese (Traditional)
- `kor` - Korean
- `ara` - Arabic
- `rus` - Russian

## OCR Engines

### Tesseract
- Fast and reliable
- Good for clean, high-quality documents
- Provides confidence scores
- Supports 100+ languages
- Currently configured with English and Vietnamese

### EasyOCR
- Better for complex layouts
- Handles skewed text well
- Good for handwritten text
- Slower but more accurate for difficult images
- Supports 80+ languages out of the box

## Architecture Notes

- **ARM64 Optimized**: Built specifically for Apple Silicon
- **Multi-stage Processing**: Tries direct PDF text extraction before OCR
- **Image Preprocessing**: Automatic denoising and thresholding
- **Memory Efficient**: Processes files one at a time to minimize memory usage

## Development

### Local Development Setup

1. Install dependencies:
```bash
pip install -r requirements.txt
```

2. Install system dependencies (macOS):
```bash
brew install tesseract poppler
```

3. Run locally:
```bash
python converter.py data/1.pdf
python api.py  # For web service
```

### Building for Different Platforms

```bash
# Build for ARM64 (Apple Silicon)
docker buildx build --platform linux/arm64 -t document-converter:arm64 .

# Build for AMD64
docker buildx build --platform linux/amd64 -t document-converter:amd64 .
```

## Troubleshooting

### Common Issues

1. **Low OCR accuracy**: Try preprocessing the image or using a different OCR engine
2. **Memory issues**: Process files individually rather than in large batches
3. **Slow performance**: Use Tesseract for faster processing, EasyOCR for better accuracy

### Performance Tips

- Use direct PDF text extraction when possible (faster than OCR)
- Preprocess images for better OCR results
- Consider using smaller image resolutions for faster processing
- Use batch processing for multiple files

## 🐳 Docker Hub

**Pull the latest image:**
```bash
docker pull truongginjs/ocr-converter:latest
```

**Available tags:**
- `truongginjs/ocr-converter:latest` - Latest stable version
- `truongginjs/ocr-converter:0.1` - Version 0.1

**Docker Hub Repository:** [truongginjs/ocr-converter](https://hub.docker.com/r/truongginjs/ocr-converter)

## 👨‍💻 Author

**Truong Nguyen**
- GitHub: [@truongginjs](https://github.com/truongginjs)
- Docker Hub: [truongginjs](https://hub.docker.com/u/truongginjs)

## ☕ Support

If this project helped you, consider buying me a coffee!

[![Buy Me A Coffee](https://img.shields.io/badge/Buy%20Me%20A%20Coffee-☕-yellow?style=for-the-badge&logo=buy-me-a-coffee)](https://coff.ee/truongginjj)

Your support helps maintain and improve this project! 🙏

## 📄 License

MIT License - Feel free to use and modify as needed.

## Changelog 📝

### Version 1.1 (Current)
- 🎯 **Multi-Platform Support**: Now builds for both ARM64 and AMD64 architectures
- 🔧 Improved Docker buildx integration for seamless cross-platform deployment
- 📦 Enhanced publishing pipeline with automated multi-platform builds
- ✅ Maintained full compatibility with previous features (English + Vietnamese)
- 🚀 Available on Docker Hub as `truongginjs/ocr-converter:1.1`

### Version 0.2
- ✅ Added Vietnamese language support (`tesseract-ocr-vie`)
- ✅ Updated documentation with comprehensive language support guide
- ✅ Added instructions for adding more languages
- ✅ Improved Docker Hub integration
- 🆕 Available on Docker Hub as `truongginjs/ocr-converter:0.2`

### Version 0.1
- 🎉 Initial release
- ✅ English language support
- ✅ Multiple input formats (PDF, images)
- ✅ Multiple output formats (TXT, JSON)
- ✅ Tesseract and EasyOCR engines
- ✅ ARM64 optimization
- ✅ REST API and CLI interfaces

## Contributing 🤝

We welcome contributions! Here are some ways you can help:

1. **Add Language Support**: Help us add more languages by updating the Dockerfile
2. **Improve OCR Accuracy**: Contribute to image preprocessing algorithms
3. **Add Features**: API enhancements, new output formats, etc.
4. **Documentation**: Help improve our documentation and examples
5. **Testing**: Test with different document types and languages

### Pull Request Guidelines
- Test your changes thoroughly
- Update documentation if needed
- Add appropriate language packages to Dockerfile
- Follow the existing code style

## Development & Publishing 🔧

### Local Development
```bash
# Clone the repository
git clone https://github.com/truongginjs/ocr-converter.git
cd ocr-converter

# Build locally
./build.sh

# Test the build
./test.sh
```

### Publishing to Docker Hub
For maintainers to publish new versions:

```bash
# Login to Docker Hub
docker login

# Build and publish multi-platform images
./publish.sh
```

The `publish.sh` script will:
- Build for both ARM64 and AMD64 architectures
- Tag with version number (1.1) and latest
- Push to Docker Hub automatically
- Verify multi-platform compatibility

### Manual Publishing
```bash
# Create multi-platform builder
docker buildx create --name multiplatform-builder --use

# Build and push
docker buildx build --platform linux/arm64,linux/amd64 \
  -t truongginjs/ocr-converter:1.1 \
  -t truongginjs/ocr-converter:latest \
  --push .
```

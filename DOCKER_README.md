# OCR Converter

A powerful Python-based document converter application that performs Optical Character Recognition (OCR) on PDF documents and images, extracting text content with high accuracy.

## 🚀 Features

- **Multi-format Support**: Process PDF files and various image formats (JPG, PNG, BMP, TIFF, WEBP)
- **Advanced OCR**: Powered by Tesseract OCR and EasyOCR for superior text extraction
- **Multi-language Support**: Supports English and Vietnamese, with easy expansion for more languages
- **REST API**: FastAPI-based web service for easy integration
- **Docker Ready**: Fully containerized for consistent deployment
- **Multi-Platform Support**: Compatible with ARM64 (Apple Silicon) and AMD64 architectures
- **Batch Processing**: Process multiple files simultaneously
- **Image Preprocessing**: Automatic image enhancement for better OCR accuracy

## 📋 Dependencies

### System Dependencies
- Tesseract OCR with multiple language packs
- Poppler utilities for PDF processing
- OpenGL and graphics libraries for image processing

### Python Dependencies
- OpenCV for image processing
- PyTesseract for OCR integration
- Pillow for image manipulation
- PyPDF2 and pdf2image for PDF processing
- EasyOCR for advanced text recognition
- FastAPI and Uvicorn for web API

## 🏃‍♂️ Quick Start

### Option 1: One-Click Deploy (Recommended for beginners)
```bash
# Download and run the deployment script
curl -O https://raw.githubusercontent.com/truongginjs/ocr-converter/main/deploy.sh
chmod +x deploy.sh
./deploy.sh
```

### Option 2: Pull and Run
```bash
# Pull the latest image (multi-platform support)
docker pull truongginjs/ocr-converter:latest

# Or pull specific version
docker pull truongginjs/ocr-converter:1.1

# Run the container
docker run -d \
  --name ocr-converter \
  -p 8000:8000 \
  -v $(pwd)/input:/app/input \
  -v $(pwd)/output:/app/output \
  truongginjs/ocr-converter:latest
```

### Option 3: Using Docker Compose
```bash
# Download docker-compose.yml
curl -O https://raw.githubusercontent.com/truongginjs/ocr-converter/main/docker-compose.yml

# Start English API service
docker-compose up document-converter

# Start Vietnamese API service  
docker-compose --profile vietnamese up document-converter-vie

# Use CLI for batch processing
docker-compose --profile cli run --rm document-converter-cli /app/input -o /app/output -l eng
```

### Using with API
Once running, the FastAPI service will be available at `http://localhost:8000`

### Direct File Processing
```bash
# Process files directly (English default)
docker run --rm \
  -v $(pwd)/input:/app/input \
  -v $(pwd)/output:/app/output \
  truongginjs/ocr-converter:latest

# Process with Vietnamese language support
docker run --rm \
  -v $(pwd)/input:/app/input \
  -v $(pwd)/output:/app/output \
  truongginjs/ocr-converter:latest \
  python converter.py /app/input -o /app/output -l vie

# Process with multiple languages
docker run --rm \
  -v $(pwd)/input:/app/input \
  -v $(pwd)/output:/app/output \
  truongginjs/ocr-converter:latest \
  python converter.py /app/input -o /app/output -l eng,vie
```

## 📁 Volume Mounts

- `/app/input` - Place your PDF files and images here for processing
- `/app/output` - Processed text files will be saved here

## 🔧 Usage Examples

### Example 1: Process a PDF file with language selection
```bash
# Place your PDF in the input directory
mkdir -p input output
cp your-document.pdf input/

# Run with English (default)
docker run --rm \
  -v $(pwd)/input:/app/input \
  -v $(pwd)/output:/app/output \
  truongginjs/ocr-converter:latest

# Run with Vietnamese language
docker run --rm \
  -v $(pwd)/input:/app/input \
  -v $(pwd)/output:/app/output \
  truongginjs/ocr-converter:latest \
  python converter.py /app/input/your-document.pdf -o /app/output -l vie -f txt

# Run with both English and Vietnamese
docker run --rm \
  -v $(pwd)/input:/app/input \
  -v $(pwd)/output:/app/output \
  truongginjs/ocr-converter:latest \
  python converter.py /app/input/your-document.pdf -o /app/output -l eng,vie -f json

# Check the output directory for extracted text
ls output/
```

### Example 2: Using the API
```bash
# Start the API server
docker run -d -p 8000:8000 --name ocr-api truongginjs/ocr-converter:latest

# Upload and process via API (English default)
curl -X POST "http://localhost:8000/upload" \
  -H "accept: application/json" \
  -H "Content-Type: multipart/form-data" \
  -F "file=@your-document.pdf"

# Upload and process with Vietnamese language
curl -X POST "http://localhost:8000/upload" \
  -H "accept: application/json" \
  -H "Content-Type: multipart/form-data" \
  -F "file=@your-document.pdf" \
  -F "language=vie"

# Visit API documentation
open http://localhost:8000/docs
```

## 🌐 Supported Languages

### Currently Active
- **English** (eng) - Default language
- **Vietnamese** (vie) - Latest version

### Available to Enable
You can easily add more languages by modifying the Dockerfile:
- **French** (fra) - Ready to uncomment
- **German** (deu) - Ready to uncomment  
- **Spanish** (spa) - Ready to uncomment

### How to Add More Languages
1. Check available languages: `docker run --rm truongginjs/ocr-converter:latest tesseract --list-langs`
2. Fork the repository and modify the Dockerfile
3. Uncomment or add desired language packages:
   ```dockerfile
   tesseract-ocr-fra \    # French
   tesseract-ocr-deu \    # German
   tesseract-ocr-spa \    # Spanish
   tesseract-ocr-ita \    # Italian
   tesseract-ocr-jpn \    # Japanese
   ```
4. Build and push your custom version

### Usage with Languages
```bash
# Single language
docker run --rm -v $(pwd)/input:/app/input -v $(pwd)/output:/app/output \
  truongginjs/ocr-converter:latest python converter.py /app/input/doc.pdf -l vie

# Multiple languages
docker run --rm -v $(pwd)/input:/app/input -v $(pwd)/output:/app/output \
  truongginjs/ocr-converter:latest python converter.py /app/input/doc.pdf -l eng,vie
```

## 🛠️ Configuration

The application can be configured through environment variables:

- `INPUT_DIR`: Input directory path (default: `/app/input`)
- `OUTPUT_DIR`: Output directory path (default: `/app/output`)
- `API_PORT`: API server port (default: `8000`)
- `OCR_LANGUAGE`: Default OCR language (default: `eng`)
- `OCR_ENGINE`: OCR engine to use (`tesseract` or `easyocr`, default: `tesseract`)

### Example with Environment Variables
```bash
docker run -d \
  -p 8000:8000 \
  -e OCR_LANGUAGE=vie \
  -e OCR_ENGINE=tesseract \
  -v $(pwd)/input:/app/input \
  -v $(pwd)/output:/app/output \
  truongginjs/ocr-converter:latest
```

## 📊 Performance

- **Architecture**: Optimized for ARM64 processors
- **Size**: ~1.4GB (includes all OCR dependencies)
- **Memory**: Recommended minimum 2GB RAM
- **Processing**: Supports batch processing of multiple files

## 🔍 Example Output

Input: PDF document with text and images
Output: Clean text file with extracted content, maintaining structure and formatting where possible.

## 📝 Version History

- **latest** (Current): Vietnamese language support
  - ✅ Added Vietnamese OCR support (`tesseract-ocr-vie`)
  - ✅ Enhanced language configuration options
  - ✅ Improved API with language parameters
  - ✅ Updated documentation and examples
  - 🌟 Better multi-language processing capabilities

- **v0.1**: Initial release with core OCR functionality
  - ✅ Tesseract OCR integration
  - ✅ PDF and image support
  - ✅ English language recognition
  - ✅ FastAPI web service
  - ✅ Docker containerization
  - ✅ ARM64 architecture optimization

## 🤝 Contributing

This image is maintained and updated regularly. For issues or feature requests, please contact the maintainer.

## �‍💻 Author

**Truong Nguyen**
- GitHub: [@truongginjs](https://github.com/truongginjs)
- Docker Hub: [truongginjs](https://hub.docker.com/u/truongginjs)

## ☕ Support

If this Docker image helped you, consider buying me a coffee!

[![Buy Me A Coffee](https://img.shields.io/badge/Buy%20Me%20A%20Coffee-☕-yellow?style=for-the-badge&logo=buy-me-a-coffee)](https://coff.ee/truongginjj)

Your support helps maintain and improve this project! 🙏

## �📄 License

This Docker image contains open-source components. Please refer to individual component licenses for specific terms.

## 🏷️ Tags

- `truongginjs/ocr-converter:latest` - Latest stable version with Vietnamese support
- `truongginjs/ocr-converter:0.2` - Version 0.2 with Vietnamese support  
- `truongginjs/ocr-converter:0.1` - Version 0.1 (English only)

## 🔗 Links

- **Docker Hub**: [truongginjs/ocr-converter](https://hub.docker.com/r/truongginjs/ocr-converter)
- **GitHub Repository**: [truongginjs/ocr-converter](https://github.com/truongginjs/ocr-converter)
- **Architecture**: ARM64
- **Base Image**: python:3.11-slim

---

**Built with ❤️ for efficient document processing**

## 🔧 Troubleshooting

### Common Issues

**1. Language not supported error**
```bash
# Check available languages
docker run --rm truongginjs/ocr-converter:latest tesseract --list-langs

# Verify you're using correct language codes
docker run --rm truongginjs/ocr-converter:latest python converter.py /app/input/test.pdf -l eng
```

**2. Permission denied on output directory**
```bash
# Fix permissions
chmod 755 output/
sudo chown -R $USER:$USER output/
```

**3. Container exits immediately**
```bash
# Check logs
docker logs ocr-converter

# Run in interactive mode to debug
docker run -it --rm truongginjs/ocr-converter:latest /bin/bash
```

**4. API not accessible**
```bash
# Check if container is running
docker ps

# Check port mapping
docker port ocr-converter

# Test API endpoint
curl http://localhost:8000/health
```

### Performance Tips

- **Memory**: Allocate at least 2GB RAM to Docker
- **Storage**: Ensure sufficient disk space for large PDF files
- **Languages**: Use specific language codes instead of 'auto' for better performance
- **Batch Processing**: Process multiple files in one container run for efficiency

### Getting Help

1. **Check logs**: `docker logs <container-name>`
2. **Test languages**: `docker run --rm truongginjs/ocr-converter:latest tesseract --list-langs`
3. **Validate input**: Ensure PDF files are not corrupted
4. **API docs**: Visit `http://localhost:8000/docs` when service is running

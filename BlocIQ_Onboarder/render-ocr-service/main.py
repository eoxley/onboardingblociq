import os
import json
import tempfile
from pathlib import Path
from typing import Optional
import pytesseract
from PIL import Image
from pdf2image import convert_from_path
from fastapi import FastAPI, File, UploadFile, HTTPException
from fastapi.middleware.cors import CORSMiddleware
import uvicorn

# Try to import Google Vision, but don't fail if not available
try:
    from google.cloud import vision
    vision_available = True
except ImportError:
    vision_available = False
    vision = None

app = FastAPI(
    title="BlocIQ OCR Service",
    description="OCR service supporting Tesseract and Google Vision API",
    version="1.0.0"
)

# Get allowed origins from environment or use defaults
allowed_origins_str = os.getenv("ALLOWED_ORIGINS", "https://www.blociq.co.uk,https://blociq-h3xv-bf7j9j1tw-eleanoroxley-9774s-projects.vercel.app")
allowed_origins = [origin.strip() for origin in allowed_origins_str.split(',')]

print(f"Configured CORS origins: {allowed_origins}")

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=allowed_origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Initialize Google Vision client if credentials are provided
vision_client = None
if vision_available:
    credentials_json = os.getenv("GOOGLE_CREDENTIALS_JSON")
    if credentials_json:
        try:
            # Parse credentials JSON and create client
            credentials_dict = json.loads(credentials_json)
            # Write credentials to temporary file for Google client
            with tempfile.NamedTemporaryFile(mode='w', suffix='.json', delete=False) as f:
                json.dump(credentials_dict, f)
                os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = f.name
            vision_client = vision.ImageAnnotatorClient()
            print("Google Vision client initialized successfully")
        except Exception as e:
            print(f"Failed to initialize Google Vision: {e}")

def extract_text_with_tesseract(image_path: str) -> str:
    """Extract text using Tesseract OCR"""
    try:
        image = Image.open(image_path)
        # Configure Tesseract for better accuracy
        custom_config = r'--oem 3 --psm 6'
        text = pytesseract.image_to_string(image, config=custom_config)
        image.close()  # Close image to free memory
        return text.strip()
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Tesseract OCR failed: {str(e)}")

def extract_text_with_google_vision(image_path: str) -> str:
    """Extract text using Google Vision API"""
    if not vision_client:
        raise HTTPException(status_code=500, detail="Google Vision not configured")
    
    try:
        with open(image_path, 'rb') as image_file:
            content = image_file.read()
        
        image = vision.Image(content=content)
        response = vision_client.text_detection(image=image)
        
        if response.error.message:
            raise Exception(f"Google Vision API error: {response.error.message}")
        
        texts = response.text_annotations
        if texts:
            return texts[0].description.strip()
        else:
            return ""
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Google Vision OCR failed: {str(e)}")

def process_pdf(file_path: str, use_google_vision: bool = False) -> tuple[str, str]:
    """Process PDF file and extract text from all pages"""
    import gc
    
    try:
        # Convert PDF to images (reduced DPI for faster processing)
        images = convert_from_path(file_path, dpi=150)
        extracted_texts = []
        
        # Limit to first 100 pages for very large documents
        max_pages = min(len(images), 100)
        
        for i, image in enumerate(images[:max_pages]):
            # Save image temporarily
            with tempfile.NamedTemporaryFile(suffix='.png', delete=False) as temp_img:
                image.save(temp_img.name, 'PNG')
                temp_img_path = temp_img.name
            
            try:
                # Extract text from this page
                if use_google_vision and vision_client:
                    page_text = extract_text_with_google_vision(temp_img_path)
                    source = "google-vision"
                else:
                    page_text = extract_text_with_tesseract(temp_img_path)
                    source = "tesseract"
                
                if page_text.strip():
                    extracted_texts.append(f"--- Page {i+1} ---\n{page_text}")
            finally:
                # Clean up temporary image
                try:
                    os.unlink(temp_img_path)
                except:
                    pass
            
            # Explicitly close and delete the image to free memory
            image.close()
            del image
            
            # Force garbage collection every 10 pages
            if (i + 1) % 10 == 0:
                gc.collect()
        
        # Clean up images list
        images.clear()
        del images
        
        # Final garbage collection
        gc.collect()
        
        combined_text = "\n\n".join(extracted_texts)
        return combined_text, source
        
    except Exception as e:
        # Ensure cleanup even on error
        import gc
        gc.collect()
        raise HTTPException(status_code=500, detail=f"PDF processing failed: {str(e)}")

@app.get("/")
async def health_check():
    """Health check endpoint"""
    return {
        "message": "BlocIQ OCR Service is running",
        "tesseract_available": True,
        "google_vision_available": vision_client is not None,
        "supabase_available": True,
        "allowed_origins": allowed_origins
    }

@app.post("/upload")
async def upload_file(
    file: UploadFile = File(...),
    use_google_vision: Optional[bool] = False
):
    """
    Upload and process a file for OCR
    
    - **file**: PDF or image file to process
    - **use_google_vision**: Use Google Vision API instead of Tesseract (requires credentials)
    """
    
    print(f"Processing file: {file.filename}, content_type: {file.content_type}")
    
    # Validate file type
    allowed_types = {
        'application/pdf': ['.pdf'],
        'image/jpeg': ['.jpg', '.jpeg'],
        'image/png': ['.png'],
        'image/tiff': ['.tiff', '.tif'],
        'image/bmp': ['.bmp']
    }
    
    if file.content_type not in allowed_types:
        raise HTTPException(
            status_code=400, 
            detail=f"Unsupported file type: {file.content_type}. Supported types: {list(allowed_types.keys())}"
        )
    
    # Check if Google Vision is requested but not available
    if use_google_vision and not vision_client:
        raise HTTPException(
            status_code=400, 
            detail="Google Vision API requested but not configured. Please set GOOGLE_CREDENTIALS_JSON environment variable."
        )
    
    # Save uploaded file temporarily
    with tempfile.NamedTemporaryFile(delete=False, suffix=Path(file.filename).suffix) as temp_file:
        content = await file.read()
        temp_file.write(content)
        temp_file_path = temp_file.name
    
    try:
        # Process based on file type
        if file.content_type == 'application/pdf':
            extracted_text, source = process_pdf(temp_file_path, use_google_vision)
        else:
            # Process image file
            if use_google_vision and vision_client:
                extracted_text = extract_text_with_google_vision(temp_file_path)
                source = "google-vision"
            else:
                extracted_text = extract_text_with_tesseract(temp_file_path)
                source = "tesseract"
        
        print(f"OCR completed: {len(extracted_text)} characters extracted using {source}")
        
        return {
            "text": extracted_text,
            "source": source,
            "filename": file.filename,
            "content_type": file.content_type
        }
    finally:
        # Clean up uploaded file
        try:
            os.unlink(temp_file_path)
        except:
            pass

if __name__ == "__main__":
    port = int(os.getenv("PORT", "8000"))
    uvicorn.run(app, host="0.0.0.0", port=port)

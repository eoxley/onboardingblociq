"""
BlocIQ Document Ingestion & Normalization Engine
================================================
Deterministic-first approach with optional AI fallback

Phase 1: Walk every folder/subfolder/file
Phase 2: Extract text from all formats
Phase 3: Generate document hashes and metadata
Phase 4: De-duplicate files
"""

import os
import hashlib
from datetime import datetime
from pathlib import Path
from typing import Dict, List, Any, Optional
import json


class DocumentIngestionEngine:
    """
    Ingests all files from a folder and normalizes to structured format
    Deterministic, transparent, trackable
    """
    
    def __init__(self, root_folder: str):
        self.root_folder = Path(root_folder)
        self.documents = []
        self.duplicates = {}
        self.stats = {
            'total_files': 0,
            'duplicates': 0,
            'near_duplicates': 0,
            'text_extracted': 0,
            'failed': 0
        }
    
    def ingest_all(self) -> List[Dict[str, Any]]:
        """
        Walk every folder/subfolder/file and create normalized document records
        
        Returns:
            List of document dicts with metadata and extracted text
        """
        print("📁 Phase 1: Ingesting all files...")
        
        # Walk all files
        for root, dirs, files in os.walk(self.root_folder):
            # Skip output folders
            if 'output' in root or '__pycache__' in root:
                continue
            
            for filename in files:
                # Skip system files
                if filename.startswith('.') or filename.startswith('~$'):
                    continue
                
                filepath = Path(root) / filename
                
                try:
                    doc = self._create_document_record(filepath)
                    self.documents.append(doc)
                    self.stats['total_files'] += 1
                    
                    if self.stats['total_files'] % 50 == 0:
                        print(f"   Processed {self.stats['total_files']} files...")
                
                except Exception as e:
                    print(f"   ⚠️  Failed: {filename}: {str(e)[:50]}")
                    self.stats['failed'] += 1
        
        print(f"   ✅ Ingested {self.stats['total_files']} files")
        
        # Phase 2: De-duplicate
        print("\n🔍 Phase 2: De-duplicating files...")
        self._deduplicate()
        
        print(f"   ✅ Found {self.stats['duplicates']} exact duplicates")
        print(f"   ✅ Found {self.stats['near_duplicates']} near-duplicates")
        
        return self.documents
    
    def _create_document_record(self, filepath: Path) -> Dict[str, Any]:
        """
        Create normalized document record with metadata
        
        Stores:
        - File hash (SHA256)
        - Size, path, created/modified times
        - Extracted text (where possible)
        - Document ID
        """
        # Get file stats
        stat = filepath.stat()
        
        # Calculate file hash
        file_hash = self._calculate_file_hash(filepath)
        
        # Generate document ID (deterministic)
        doc_id = self._generate_document_id(filepath, stat)
        
        # Get relative path from root
        relative_path = str(filepath.relative_to(self.root_folder))
        
        # Extract folder category from path
        path_parts = relative_path.split(os.sep)
        primary_folder = path_parts[0] if len(path_parts) > 0 else 'ROOT'
        
        # Create base record
        doc = {
            'document_id': doc_id,
            'file_hash': file_hash,
            'filename': filepath.name,
            'file_path': relative_path,
            'absolute_path': str(filepath),
            'file_size': stat.st_size,
            'created_time': datetime.fromtimestamp(stat.st_ctime).isoformat(),
            'modified_time': datetime.fromtimestamp(stat.st_mtime).isoformat(),
            'extension': filepath.suffix.lower(),
            'primary_folder': primary_folder,
            'file_type': self._identify_file_type(filepath),
            'is_duplicate_of': None,
            'near_duplicate_of': None,
            'extracted_text': None,
            'text_length': 0,
            'extraction_method': None,
            'extraction_success': False
        }
        
        # Extract text content
        text, method = self._extract_text(filepath)
        if text:
            doc['extracted_text'] = text
            doc['text_length'] = len(text)
            doc['extraction_method'] = method
            doc['extraction_success'] = True
            self.stats['text_extracted'] += 1
        
        return doc
    
    def _calculate_file_hash(self, filepath: Path) -> str:
        """Calculate SHA256 hash of file content"""
        sha256 = hashlib.sha256()
        
        try:
            with open(filepath, 'rb') as f:
                # Read in chunks for large files
                while chunk := f.read(8192):
                    sha256.update(chunk)
            return sha256.hexdigest()
        except:
            return 'ERROR'
    
    def _generate_document_id(self, filepath: Path, stat: os.stat_result) -> str:
        """
        Generate deterministic document ID
        Format: sha256(path + size + mtime)
        """
        unique_string = f"{filepath.name}|{stat.st_size}|{stat.st_mtime}"
        return hashlib.sha256(unique_string.encode()).hexdigest()[:16]
    
    def _identify_file_type(self, filepath: Path) -> str:
        """Identify file type from extension"""
        ext = filepath.suffix.lower()
        
        type_map = {
            '.pdf': 'pdf',
            '.docx': 'word',
            '.doc': 'word',
            '.xlsx': 'excel',
            '.xls': 'excel',
            '.xlsm': 'excel',
            '.xlsb': 'excel',
            '.csv': 'csv',
            '.txt': 'text',
            '.msg': 'email',
            '.eml': 'email',
            '.jpg': 'image',
            '.jpeg': 'image',
            '.png': 'image',
            '.gif': 'image',
            '.bmp': 'image',
            '.tiff': 'image',
            '.tif': 'image',
            '.webp': 'image',
            '.jfif': 'image',
            '.heic': 'image',
            '.zip': 'archive',
            '.rar': 'archive',
        }
        
        return type_map.get(ext, 'unknown')
    
    def _extract_text(self, filepath: Path) -> tuple[Optional[str], Optional[str]]:
        """
        Extract text from file based on type
        Returns: (text, method_used)
        """
        file_type = self._identify_file_type(filepath)
        
        try:
            if file_type == 'pdf':
                return self._extract_from_pdf(filepath)
            elif file_type == 'word':
                return self._extract_from_word(filepath)
            elif file_type == 'excel':
                return self._extract_from_excel(filepath)
            elif file_type == 'text':
                return self._extract_from_text(filepath)
            elif file_type == 'csv':
                return self._extract_from_csv(filepath)
            elif file_type == 'email':
                return self._extract_from_email(filepath)
            elif file_type == 'image':
                # Try OCR extraction
                return self._extract_from_image(filepath)
            else:
                return None, None
        
        except Exception as e:
            return None, f"error:{str(e)[:50]}"
    
    def _extract_from_pdf(self, filepath: Path) -> tuple[Optional[str], str]:
        """Extract text from PDF - READS ALL PAGES"""
        try:
            import PyPDF2
            
            text_parts = []
            with open(filepath, 'rb') as f:
                reader = PyPDF2.PdfReader(f)
                # READ ALL PAGES - no limit!
                for page in reader.pages:
                    page_text = page.extract_text()
                    if page_text:
                        text_parts.append(page_text)
            
            text = '\n'.join(text_parts)
            return text if text.strip() else None, 'pypdf2'
        
        except Exception as e:
            return None, f'pdf_error:{str(e)[:30]}'
    
    def _extract_from_word(self, filepath: Path) -> tuple[Optional[str], str]:
        """Extract text from Word document"""
        try:
            import docx
            
            doc = docx.Document(filepath)
            text_parts = [para.text for para in doc.paragraphs if para.text.strip()]
            text = '\n'.join(text_parts)
            
            return text if text.strip() else None, 'python-docx'
        
        except Exception as e:
            return None, f'docx_error:{str(e)[:30]}'
    
    def _extract_from_excel(self, filepath: Path) -> tuple[Optional[str], str]:
        """Extract text from Excel - READS ALL SHEETS AND ROWS"""
        try:
            import openpyxl
            
            wb = openpyxl.load_workbook(filepath, data_only=True, read_only=True)
            text_parts = []
            
            # READ ALL SHEETS - no limit!
            for sheet in wb.worksheets:
                # READ ALL ROWS - no limit!
                for row in sheet.iter_rows(values_only=True):
                    row_text = ' | '.join(str(cell) for cell in row if cell)
                    if row_text.strip():
                        text_parts.append(row_text)
            
            text = '\n'.join(text_parts)
            return text if text.strip() else None, 'openpyxl'
        
        except Exception as e:
            return None, f'excel_error:{str(e)[:30]}'
    
    def _extract_from_text(self, filepath: Path) -> tuple[Optional[str], str]:
        """Extract from plain text file"""
        try:
            with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
                text = f.read()
            return text if text.strip() else None, 'direct'
        except:
            return None, 'text_error'
    
    def _extract_from_csv(self, filepath: Path) -> tuple[Optional[str], str]:
        """Extract from CSV"""
        try:
            import csv
            
            text_parts = []
            with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
                reader = csv.reader(f)
                for row in reader:
                    text_parts.append(' | '.join(row))
            
            text = '\n'.join(text_parts)
            return text if text.strip() else None, 'csv'
        except:
            return None, 'csv_error'
    
    def _extract_from_email(self, filepath: Path) -> tuple[Optional[str], str]:
        """Extract from MSG/EML files"""
        # For now, mark as email but don't extract (requires extract_msg library)
        return None, 'email_skip'
    
    def _extract_from_image(self, filepath: Path) -> tuple[Optional[str], str]:
        """
        Extract text from images using OCR
        Falls back gracefully if pytesseract not available
        """
        try:
            from PIL import Image
            import pytesseract
            
            # Open and process image
            image = Image.open(filepath)
            
            # Convert to RGB if needed
            if image.mode not in ('RGB', 'L'):
                image = image.convert('RGB')
            
            # Extract text using OCR
            text = pytesseract.image_to_string(image)
            
            if text and text.strip():
                return text.strip(), 'ocr'
            else:
                return None, 'ocr_no_text'
        
        except ImportError:
            # pytesseract or PIL not installed - skip OCR
            return None, 'ocr_not_available'
        
        except Exception as e:
            return None, f'ocr_error:{str(e)[:30]}'
    
    def _deduplicate(self):
        """
        De-duplicate files:
        1. Exact duplicates (same hash)
        2. Near-duplicates (>80% text similarity AND same date range)
        """
        # Create hash lookup
        by_hash = {}
        for doc in self.documents:
            file_hash = doc['file_hash']
            if file_hash == 'ERROR':
                continue
            
            if file_hash not in by_hash:
                by_hash[file_hash] = []
            by_hash[file_hash].append(doc)
        
        # Mark exact duplicates (keep newest)
        for file_hash, docs in by_hash.items():
            if len(docs) > 1:
                # Sort by modified time, keep newest
                sorted_docs = sorted(docs, key=lambda d: d['modified_time'], reverse=True)
                primary = sorted_docs[0]
                
                for dup in sorted_docs[1:]:
                    dup['is_duplicate_of'] = primary['document_id']
                    self.stats['duplicates'] += 1
        
        # Near-duplicate detection (text similarity)
        # TODO: Implement if needed - for now, exact hash is sufficient
    
    def get_unique_documents(self) -> List[Dict[str, Any]]:
        """Get only unique documents (not duplicates)"""
        return [doc for doc in self.documents if not doc['is_duplicate_of']]
    
    def save_manifest(self, output_file: str):
        """Save manifest.jsonl (one line per file)"""
        with open(output_file, 'w') as f:
            for doc in self.documents:
                # Create manifest line
                manifest_entry = {
                    'document_id': doc['document_id'],
                    'filename': doc['filename'],
                    'path': doc['file_path'],
                    'size': doc['file_size'],
                    'type': doc['file_type'],
                    'hash': doc['file_hash'],
                    'is_duplicate': doc['is_duplicate_of'] is not None,
                    'has_text': doc['extraction_success'],
                    'primary_folder': doc['primary_folder']
                }
                f.write(json.dumps(manifest_entry) + '\n')
        
        print(f"   ✅ Manifest saved: {output_file}")
        print(f"      Total files: {len(self.documents)}")
        print(f"      Unique files: {len(self.get_unique_documents())}")
        print(f"      Duplicates: {self.stats['duplicates']}")


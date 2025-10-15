#!/usr/bin/env python3
"""
Supplier Onboarding Desktop App
================================
Simple GUI for onboarding suppliers/contractors

Features:
- Select supplier document folder
- Automatic data extraction
- SQL generation
- Direct database application
- Visual results display
"""

import os
import sys
import tkinter as tk
from tkinter import ttk, filedialog, messagebox, scrolledtext
import threading
from pathlib import Path
import json

# Suppress Tkinter warning on macOS
os.environ['TK_SILENCE_DEPRECATION'] = '1'

# Import our modules
from contractor_extractor import ContractorExtractor
from contractor_sql_generator import SupplierSQLGenerator


class SupplierOnboardingApp:
    """Simple desktop app for supplier onboarding"""
    
    def __init__(self, root):
        self.root = root
        self.root.title("BlocIQ Supplier Onboarding")
        self.root.geometry("900x700")
        self.root.configure(bg="#f5f5f5")
        
        self.supplier_folder = tk.StringVar()
        self.is_processing = False
        self.extracted_data = None
        self.sql_content = None
        self.supplier_id = None
        
        self.setup_ui()
    
    def setup_ui(self):
        """Setup the user interface"""
        
        # Header
        header_frame = tk.Frame(self.root, bg="#2c5aa0", height=80)
        header_frame.pack(fill=tk.X)
        header_frame.pack_propagate(False)
        
        title_label = tk.Label(
            header_frame,
            text="🔨 Supplier Onboarding System",
            font=("Helvetica", 20, "bold"),
            bg="#2c5aa0",
            fg="white"
        )
        title_label.pack(pady=25)
        
        # Main content area
        content_frame = tk.Frame(self.root, bg="#f5f5f5")
        content_frame.pack(fill=tk.BOTH, expand=True, padx=20, pady=20)
        
        # Folder selection
        folder_frame = tk.LabelFrame(
            content_frame,
            text="1. Select Supplier Document Folder",
            font=("Helvetica", 12, "bold"),
            bg="#f5f5f5",
            padx=10,
            pady=10
        )
        folder_frame.pack(fill=tk.X, pady=(0, 10))
        
        folder_entry_frame = tk.Frame(folder_frame, bg="#f5f5f5")
        folder_entry_frame.pack(fill=tk.X)
        
        self.folder_entry = tk.Entry(
            folder_entry_frame,
            textvariable=self.supplier_folder,
            font=("Helvetica", 11),
            width=60
        )
        self.folder_entry.pack(side=tk.LEFT, padx=(0, 10), fill=tk.X, expand=True)
        
        browse_folder_btn = tk.Button(
            folder_entry_frame,
            text="Browse Folder...",
            command=self.browse_folder,
            font=("Helvetica", 10),
            bg="#4a90e2",
            fg="white",
            padx=15,
            cursor="hand2"
        )
        browse_folder_btn.pack(side=tk.LEFT, padx=(0, 5))
        
        browse_files_btn = tk.Button(
            folder_entry_frame,
            text="Select Files...",
            command=self.browse_files,
            font=("Helvetica", 10),
            bg="#51cf66",
            fg="white",
            padx=15,
            cursor="hand2"
        )
        browse_files_btn.pack(side=tk.LEFT)
        
        # Process button
        button_frame = tk.Frame(content_frame, bg="#f5f5f5")
        button_frame.pack(fill=tk.X, pady=10)
        
        self.process_btn = tk.Button(
            button_frame,
            text="▶  Start Extraction",
            command=self.start_processing,
            font=("Helvetica", 14, "bold"),
            bg="#51cf66",
            fg="white",
            padx=40,
            pady=15,
            cursor="hand2"
        )
        self.process_btn.pack(side=tk.LEFT, padx=(0, 10))
        
        self.apply_btn = tk.Button(
            button_frame,
            text="✓ Apply to Database",
            command=self.apply_to_database,
            font=("Helvetica", 14, "bold"),
            bg="#ff6b6b",
            fg="white",
            padx=40,
            pady=15,
            cursor="hand2",
            state=tk.DISABLED
        )
        self.apply_btn.pack(side=tk.LEFT)
        
        # Progress/Results area
        results_frame = tk.LabelFrame(
            content_frame,
            text="2. Extraction Results",
            font=("Helvetica", 12, "bold"),
            bg="#f5f5f5",
            padx=10,
            pady=10
        )
        results_frame.pack(fill=tk.BOTH, expand=True, pady=(0, 10))
        
        self.results_text = scrolledtext.ScrolledText(
            results_frame,
            font=("Monaco", 10),
            bg="#ffffff",
            wrap=tk.WORD,
            height=15
        )
        self.results_text.pack(fill=tk.BOTH, expand=True)
        
        # SQL Preview
        sql_frame = tk.LabelFrame(
            content_frame,
            text="3. Generated SQL Preview",
            font=("Helvetica", 12, "bold"),
            bg="#f5f5f5",
            padx=10,
            pady=10
        )
        sql_frame.pack(fill=tk.BOTH, expand=True)
        
        self.sql_text = scrolledtext.ScrolledText(
            sql_frame,
            font=("Monaco", 9),
            bg="#ffffff",
            wrap=tk.WORD,
            height=10
        )
        self.sql_text.pack(fill=tk.BOTH, expand=True)
        
        # Status bar
        self.status_var = tk.StringVar(value="Ready")
        status_bar = tk.Label(
            self.root,
            textvariable=self.status_var,
            font=("Helvetica", 10),
            bg="#e0e0e0",
            anchor=tk.W,
            padx=10,
            pady=5
        )
        status_bar.pack(fill=tk.X, side=tk.BOTTOM)
    
    def browse_folder(self):
        """Open folder selection dialog"""
        folder = filedialog.askdirectory(
            title="Select Supplier Document Folder",
            initialdir=os.path.expanduser("~/Downloads")
        )
        if folder:
            self.supplier_folder.set(folder)
    
    def browse_files(self):
        """Open file selection dialog (multiple files)"""
        files = filedialog.askopenfilenames(
            title="Select Supplier Documents (Excel, PDF, Word)",
            initialdir=os.path.expanduser("~/Downloads"),
            filetypes=[
                ("All Supported", "*.xlsx;*.xls;*.pdf;*.docx;*.doc"),
                ("Excel files", "*.xlsx;*.xls"),
                ("PDF files", "*.pdf"),
                ("Word files", "*.docx;*.doc"),
                ("All files", "*.*")
            ]
        )
        if files:
            # Store files as a list (separated by semicolon)
            self.supplier_folder.set(";".join(files))
    
    def start_processing(self):
        """Start supplier data extraction"""
        path_input = self.supplier_folder.get()
        
        if not path_input:
            messagebox.showwarning("No Selection", "Please select a folder or files first")
            return
        
        # Check if it's files (semicolon-separated) or folder
        if ';' in path_input:
            # Multiple files selected
            files = [f for f in path_input.split(';') if f.strip()]
            if not all(Path(f).exists() for f in files):
                messagebox.showerror("File Not Found", "One or more selected files do not exist")
                return
        else:
            # Single folder selected
            if not Path(path_input).exists():
                messagebox.showerror("Not Found", f"Folder or file does not exist:\n{path_input}")
                return
        
        # Disable button during processing
        self.process_btn.config(state=tk.DISABLED)
        self.apply_btn.config(state=tk.DISABLED)
        self.is_processing = True
        
        # Clear previous results
        self.results_text.delete(1.0, tk.END)
        self.sql_text.delete(1.0, tk.END)
        
        # Run in thread to keep UI responsive
        thread = threading.Thread(target=self.process_supplier, args=(path_input,))
        thread.daemon = True
        thread.start()
    
    def process_supplier(self, path_input: str):
        """Process supplier documents (runs in background thread)"""
        
        try:
            self.log_result("="*70)
            self.log_result("🚀 SUPPLIER ONBOARDING STARTED")
            self.log_result("="*70)
            
            # Check if it's files or folder
            if ';' in path_input:
                # Multiple files selected
                files = [Path(f) for f in path_input.split(';') if f.strip()]
                self.log_result(f"Files: {len(files)} selected\n")
                for f in files[:3]:
                    self.log_result(f"   • {f.name}")
                if len(files) > 3:
                    self.log_result(f"   • ... and {len(files) - 3} more")
            else:
                # Folder selected
                self.log_result(f"Folder: {Path(path_input).name}\n")
            
            self.status_var.set("Extracting data...")
            
            # STEP 1: Extract data
            self.log_result("\n📥 STEP 1: Extracting Data from Documents...")
            self.log_result("-"*70)
            
            extractor = ContractorExtractor()
            
            # Handle both folder and file list
            if ';' in path_input:
                self.extracted_data = extractor.extract_from_files([Path(f) for f in path_input.split(';') if f.strip()])
            else:
                self.extracted_data = extractor.extract_from_folder(path_input)
            
            # Display results
            self.log_result("\n✅ EXTRACTION COMPLETE!\n")
            self.log_result(f"📊 Results:")
            self.log_result(f"   • Contractor Name: {self.extracted_data.get('contractor_name') or '❌ Not found'}")
            self.log_result(f"   • Email: {self.extracted_data.get('email') or '❌ Not found'}")
            self.log_result(f"   • Telephone: {self.extracted_data.get('telephone') or '❌ Not found'}")
            self.log_result(f"   • Postcode: {self.extracted_data.get('postcode') or '❌ Not found'}")
            
            services = self.extracted_data.get('services_provided', [])
            if services:
                self.log_result(f"\n   • Services ({len(services)}):")
                for service in services[:5]:
                    self.log_result(f"      - {service}")
            
            self.log_result(f"\n   • Bank Account: {self.extracted_data.get('bank_account_name') or '❌ Not found'}")
            self.log_result(f"   • Sort Code: {self.extracted_data.get('bank_sort_code') or '❌ Not found'}")
            self.log_result(f"   • PLI Expiry: {self.extracted_data.get('pli_expiry_date') or '❌ Not found'}")
            
            self.log_result(f"\n   • Audited Accounts: {'✓ Yes' if self.extracted_data.get('has_audited_accounts') else '✗ No'}")
            self.log_result(f"   • Certificate of Incorporation: {'✓ Yes' if self.extracted_data.get('has_certificate_of_incorporation') else '✗ No'}")
            
            confidence = self.extracted_data.get('extraction_confidence', 0)
            self.log_result(f"\n   📊 Confidence: {confidence:.0%}")
            
            # STEP 2: Generate SQL
            self.log_result("\n" + "-"*70)
            self.log_result("💾 STEP 2: Generating SQL...")
            self.status_var.set("Generating SQL...")
            
            generator = SupplierSQLGenerator()
            self.supplier_id = generator.supplier_id
            self.sql_content = generator.generate_sql(self.extracted_data)
            
            # Show SQL preview
            self.sql_text.insert(1.0, self.sql_content)
            
            # Save files
            output_dir = Path('output')
            output_dir.mkdir(exist_ok=True)
            
            folder_name = Path(folder_path).name
            json_file = output_dir / f"{folder_name}_supplier_data.json"
            sql_file = output_dir / f"{folder_name}_supplier.sql"
            
            with open(json_file, 'w') as f:
                json.dump(self.extracted_data, f, indent=2)
            
            with open(sql_file, 'w') as f:
                f.write(self.sql_content)
            
            self.log_result(f"\n✅ SQL Generated!")
            self.log_result(f"   📄 JSON: {json_file}")
            self.log_result(f"   💾 SQL: {sql_file}")
            self.log_result(f"   🆔 Supplier ID: {self.supplier_id}")
            
            # STEP 3: Summary
            self.log_result("\n" + "="*70)
            self.log_result("✅ EXTRACTION COMPLETE!")
            self.log_result("="*70)
            
            self.log_result(f"\n🎯 Next Steps:")
            self.log_result(f"   1. Review the data above")
            self.log_result(f"   2. Upload documents to: supplier_documents/{self.supplier_id}/")
            self.log_result(f"   3. Click 'Apply to Database' to load supplier data")
            
            # Enable apply button
            self.root.after(0, lambda: self.apply_btn.config(state=tk.NORMAL))
            self.status_var.set("Ready to apply to database")
            
        except Exception as e:
            self.log_result(f"\n❌ ERROR: {e}")
            import traceback
            self.log_result(traceback.format_exc())
            self.status_var.set("Error occurred")
        
        finally:
            # Re-enable process button
            self.root.after(0, lambda: self.process_btn.config(state=tk.NORMAL))
            self.is_processing = False
    
    def apply_to_database(self):
        """Apply the generated SQL to Supabase"""
        
        if not self.sql_content:
            messagebox.showwarning("No SQL", "Please extract supplier data first")
            return
        
        response = messagebox.askyesno(
            "Apply to Database",
            "This will add the supplier to your Supabase database.\n\n"
            f"Supplier: {self.extracted_data.get('contractor_name', 'Unknown')}\n"
            f"Supplier ID: {self.supplier_id}\n\n"
            "Continue?"
        )
        
        if not response:
            return
        
        self.apply_btn.config(state=tk.DISABLED)
        self.status_var.set("Applying to database...")
        
        # Run in thread
        thread = threading.Thread(target=self.apply_sql_thread)
        thread.daemon = True
        thread.start()
    
    def apply_sql_thread(self):
        """Apply SQL to database (background thread)"""
        
        try:
            import subprocess
            
            # Save SQL to temp file
            temp_sql = Path('output') / f"temp_supplier_{self.supplier_id}.sql"
            with open(temp_sql, 'w') as f:
                f.write(self.sql_content)
            
            self.log_result("\n" + "="*70)
            self.log_result("🚀 APPLYING TO SUPABASE DATABASE")
            self.log_result("="*70 + "\n")
            
            # Run apply script
            result = subprocess.run(
                ["python3", "apply_with_new_credentials.py", str(temp_sql)],
                capture_output=True,
                text=True,
                timeout=60
            )
            
            self.log_result(result.stdout)
            
            if result.returncode == 0:
                self.log_result("\n✅ SUPPLIER SUCCESSFULLY ADDED TO DATABASE!")
                self.log_result("\n📊 Supplier is now in Supabase:")
                self.log_result(f"   • Name: {self.extracted_data.get('contractor_name')}")
                self.log_result(f"   • ID: {self.supplier_id}")
                self.log_result(f"   • Status: Pending approval")
                
                self.status_var.set("✅ Supplier added to database!")
                
                self.root.after(0, lambda: messagebox.showinfo(
                    "Success!",
                    f"Supplier added to database!\n\n"
                    f"Name: {self.extracted_data.get('contractor_name')}\n"
                    f"ID: {self.supplier_id}\n\n"
                    f"Next: Upload documents to supplier_documents/{self.supplier_id}/"
                ))
            else:
                self.log_result(f"\n❌ Error: {result.stderr}")
                self.status_var.set("Error applying to database")
                
        except Exception as e:
            self.log_result(f"\n❌ Error applying to database: {e}")
            self.status_var.set("Error occurred")
        
        finally:
            self.root.after(0, lambda: self.apply_btn.config(state=tk.NORMAL))
    
    def log_result(self, message: str):
        """Add message to results text area (thread-safe)"""
        def append():
            self.results_text.insert(tk.END, message + "\n")
            self.results_text.see(tk.END)
            self.root.update_idletasks()
        
        if threading.current_thread() == threading.main_thread():
            append()
        else:
            self.root.after(0, append)
    
    def browse_folder(self):
        """Open folder browser"""
        folder = filedialog.askdirectory(
            title="Select Supplier Document Folder",
            initialdir=os.path.expanduser("~/Downloads")
        )
        if folder:
            self.supplier_folder.set(folder)


def main():
    """Launch the app"""
    root = tk.Tk()
    app = SupplierOnboardingApp(root)
    
    # Center window
    root.update_idletasks()
    width = root.winfo_width()
    height = root.winfo_height()
    x = (root.winfo_screenwidth() // 2) - (width // 2)
    y = (root.winfo_screenheight() // 2) - (height // 2)
    root.geometry(f'{width}x{height}+{x}+{y}')
    
    root.mainloop()


if __name__ == '__main__':
    main()


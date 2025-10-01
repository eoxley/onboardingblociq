#!/usr/bin/env python3
"""
BlocIQ Onboarder - Desktop Application
Lightweight Tkinter GUI for processing client onboarding data
"""

import os
import sys

# Suppress Tkinter deprecation warning on macOS
os.environ['TK_SILENCE_DEPRECATION'] = '1'

import tkinter as tk
from tkinter import ttk, filedialog, messagebox, scrolledtext
import threading
from pathlib import Path
import json
from datetime import datetime

# Import our existing modules
from onboarder import BlocIQOnboarder


class BlocIQOnboarderApp:
    """Main Tkinter application for BlocIQ Onboarder"""
    
    def __init__(self, root):
        self.root = root
        self.root.title("BlocIQ Onboarder")
        self.root.geometry("900x700")
        self.root.minsize(600, 500)
        self.root.resizable(True, True)
        self.root.configure(bg="white")

        # Set app icon
        try:
            icon_path = Path(__file__).parent / "icon.png"
            if icon_path.exists():
                icon = tk.PhotoImage(file=str(icon_path))
                self.root.iconphoto(True, icon)
        except Exception as e:
            print(f"Could not load icon: {e}")
        
        # Variables
        self.building_name = tk.StringVar()
        self.client_folder = tk.StringVar()
        self.is_processing = False
        
        # Debug: Print to console
        print("Initializing BlocIQ Onboarder App...")
        
        # Setup UI
        self.setup_ui()
        
        # Center the window
        self.center_window()
        
        print("App initialization complete!")
    
    def setup_ui(self):
        """Setup the user interface using pack for simpler layout"""

        # Title
        title_label = tk.Label(self.root, text="BlocIQ Onboarder",
                              font=("Arial", 20, "bold"), bg="white")
        title_label.pack(pady=20)

        # Input frame
        input_frame = tk.Frame(self.root, bg="white")
        input_frame.pack(fill=tk.X, padx=30, pady=10)

        # Building Name
        tk.Label(input_frame, text="Building Name (optional):", bg="white", font=("Arial", 12, "bold")).pack(anchor=tk.W, pady=(10, 5))
        building_entry = tk.Entry(input_frame, textvariable=self.building_name, font=("Arial", 14),
                                 relief=tk.SOLID, bd=2, highlightthickness=2, bg="#FFFACD")
        building_entry.pack(fill=tk.X, pady=(0, 15), ipady=8)
        building_entry.insert(0, "Optional - will be extracted from files if not provided")
        building_entry.bind("<FocusIn>", lambda e: building_entry.delete(0, tk.END) if "Optional" in building_entry.get() else None)
        building_entry.focus_set()

        # Client Folder
        tk.Label(input_frame, text="Client Folder:", bg="white", font=("Arial", 12, "bold")).pack(anchor=tk.W, pady=(10, 5))

        folder_frame = tk.Frame(input_frame, bg="white")
        folder_frame.pack(fill=tk.X, pady=(0, 15))

        self.folder_entry = tk.Entry(folder_frame, textvariable=self.client_folder,
                                     state="readonly", font=("Arial", 12),
                                     relief=tk.SOLID, bd=2)
        self.folder_entry.pack(side=tk.LEFT, fill=tk.X, expand=True, padx=(0, 10), ipady=5)

        tk.Button(folder_frame, text="Browse...", command=self.select_folder,
                 font=("Arial", 12, "bold"), bg="#2196F3", fg="white", padx=15, pady=5).pack(side=tk.RIGHT)

        # Buttons frame
        button_frame = tk.Frame(self.root, bg="white")
        button_frame.pack(pady=10)

        # Run Button
        self.run_button = tk.Button(button_frame, text="RUN ONBOARDER",
                                    command=self.run_onboarder,
                                    font=("Arial", 14, "bold"),
                                    bg="#4CAF50", fg="white",
                                    padx=30, pady=10)
        self.run_button.pack(side=tk.LEFT, padx=10)

        # Copy SQL Button
        self.copy_button = tk.Button(button_frame, text="📋 COPY SQL",
                                     command=self.copy_sql_to_clipboard,
                                     font=("Arial", 12, "bold"),
                                     bg="#2196F3", fg="white",
                                     padx=20, pady=10)
        self.copy_button.pack(side=tk.LEFT, padx=10)

        # Open Output Button
        self.open_button = tk.Button(button_frame, text="OPEN OUTPUT",
                                     command=self.open_output_folder,
                                     font=("Arial", 12, "bold"),
                                     bg="#FF9800", fg="white",
                                     padx=20, pady=10)
        self.open_button.pack(side=tk.LEFT, padx=10)

        # SQL Output Area (no tabs - just one big text area)
        tk.Label(self.root, text="SQL OUTPUT:", bg="white", font=("Arial", 12, "bold")).pack(anchor=tk.W, padx=30, pady=(10, 5))

        self.results_text = scrolledtext.ScrolledText(self.root, height=20, width=100,
                                                      font=("Courier", 9), wrap=tk.NONE,
                                                      bg="#f5f5f5", relief=tk.SOLID, bd=2)
        self.results_text.pack(fill=tk.BOTH, expand=True, padx=30, pady=(0, 10))

        # Status bar
        self.status_var = tk.StringVar()
        self.status_var.set("Ready")
        status_bar = tk.Label(self.root, textvariable=self.status_var,
                             relief=tk.SUNKEN, anchor=tk.W, font=("Arial", 10))
        status_bar.pack(side=tk.BOTTOM, fill=tk.X)
    
    def center_window(self):
        """Center the window on screen"""
        self.root.update_idletasks()
        width = self.root.winfo_width()
        height = self.root.winfo_height()
        x = (self.root.winfo_screenwidth() // 2) - (width // 2)
        y = (self.root.winfo_screenheight() // 2) - (height // 2)
        self.root.geometry(f"{width}x{height}+{x}+{y}")
    
    def select_folder(self):
        """Open folder selection dialog"""
        folder = filedialog.askdirectory(title="Select Client Folder")
        if folder:
            self.client_folder.set(folder)
            self.log(f"Selected folder: {folder}")

    def open_output_folder(self):
        """Open the output folder in Finder"""
        import subprocess
        output_dir = os.path.expanduser("~/Desktop/BlocIQ_Output")

        # Create folder if it doesn't exist
        os.makedirs(output_dir, exist_ok=True)

        # Open in Finder (macOS)
        subprocess.run(["open", output_dir])

    def copy_sql_to_clipboard(self):
        """Copy SQL from Results tab to clipboard"""
        sql_content = self.results_text.get(1.0, tk.END).strip()
        if sql_content:
            self.root.clipboard_clear()
            self.root.clipboard_append(sql_content)
            self.root.update()
            messagebox.showinfo("Copied!", "SQL copied to clipboard!\n\nYou can now paste it into Supabase SQL Editor.")
        else:
            messagebox.showwarning("Nothing to copy", "No SQL generated yet. Run the onboarder first.")
    
    def log(self, message):
        """Add message to results area"""
        timestamp = datetime.now().strftime("%H:%M:%S")
        self.results_text.insert(tk.END, f"[{timestamp}] {message}\n")
        self.results_text.see(tk.END)
        self.root.update_idletasks()
    
    def update_results(self, content):
        """Update results tab"""
        self.results_text.delete(1.0, tk.END)
        self.results_text.insert(tk.END, content)
        self.results_text.see(tk.END)
    
    def run_onboarder(self):
        """Run the onboarder pipeline"""
        if self.is_processing:
            messagebox.showwarning("Warning", "Onboarder is already running!")
            return

        # Validate inputs - only folder is required
        if not self.client_folder.get().strip():
            messagebox.showerror("Error", "Please select a client folder")
            return
        
        if not os.path.exists(self.client_folder.get()):
            messagebox.showerror("Error", "Selected folder does not exist")
            return
        
        # Start processing in a separate thread
        self.is_processing = True
        self.run_button.config(state="disabled")
        self.status_var.set("Processing...")
        
        # Clear output area
        self.results_text.delete(1.0, tk.END)
        
        # Start thread
        thread = threading.Thread(target=self.process_onboarder)
        thread.daemon = True
        thread.start()
    
    def process_onboarder(self):
        """Process the onboarder in a separate thread"""
        try:
            self.log("Starting BlocIQ Onboarder...")

            # Get building name, use None if it's the placeholder text
            building_name = self.building_name.get().strip()
            if "Optional" in building_name or not building_name:
                building_name = None
                self.log("Building name: Will extract from files")
            else:
                self.log(f"Building: {building_name}")

            self.log(f"Folder: {self.client_folder.get()}")

            # Use Desktop for output (user-writable location)
            import os
            output_dir = os.path.expanduser("~/Desktop/BlocIQ_Output")
            self.log(f"Output will be saved to: {output_dir}")

            # Create onboarder instance
            onboarder = BlocIQOnboarder(
                client_folder=self.client_folder.get(),
                building_name=building_name,
                output_dir=output_dir
            )
            
            # Override the onboarder's print statements to use our log
            original_print = print
            def log_print(*args, **kwargs):
                message = ' '.join(str(arg) for arg in args)
                self.log(message)
            
            # Temporarily replace print
            import builtins
            builtins.print = log_print
            
            try:
                # Run the onboarder
                onboarder.run()
                
                self.log("✅ Onboarding completed successfully!")

                # Get output location
                sql_file = Path(onboarder.output_dir) / "migration.sql"

                # Load and display the full SQL
                if sql_file.exists():
                    with open(sql_file, 'r') as f:
                        sql_content = f.read()

                    # Show SQL in Results tab
                    self.results_text.delete(1.0, tk.END)
                    self.results_text.insert(1.0, sql_content)

                    self.log(f"✅ SQL generated! ({len(sql_content)} characters)")
                    self.status_var.set(f"✅ Complete! SQL ready to copy from Results tab")

                    # Show completion message
                    self.root.after(0, lambda: messagebox.showinfo(
                        "Success",
                        f"✅ SQL Generated!\n\nClick 'COPY SQL' button to copy.\n\nAlso saved to:\n{sql_file}"
                    ))
                else:
                    self.log("⚠️ SQL file not found")
                    self.status_var.set("Warning: SQL file not generated")
                
            finally:
                # Restore original print
                builtins.print = original_print
                
        except Exception as e:
            error_msg = f"Error during processing: {str(e)}"
            self.log(f"❌ {error_msg}")
            self.status_var.set("Error occurred")
            
            # Show error message
            self.root.after(0, lambda: messagebox.showerror("Error", error_msg))
        
        finally:
            # Re-enable UI
            self.is_processing = False
            self.root.after(0, self.run_button.config, {"state": "normal"})
    
    def generate_results_summary(self, onboarder):
        """Generate results summary for display"""
        try:
            # Read generated files
            output_dir = Path(onboarder.output_dir)
            
            summary_content = "=== BLOCIQ ONBOARDER RESULTS ===\n\n"
            
            # Summary stats
            if hasattr(onboarder, 'mapped_data'):
                summary_content += "📊 SUMMARY STATISTICS:\n"
                summary_content += f"  • Building: {onboarder.building_name}\n"
                summary_content += f"  • Files Processed: {len(onboarder.parsed_files)}\n"
                
                if 'building' in onboarder.mapped_data:
                    summary_content += f"  • Building Record: ✅ Created\n"
                
                if 'units' in onboarder.mapped_data:
                    summary_content += f"  • Units: {len(onboarder.mapped_data['units'])}\n"
                
                if 'leaseholders' in onboarder.mapped_data:
                    summary_content += f"  • Leaseholders: {len(onboarder.mapped_data['leaseholders'])}\n"
                
                if 'building_documents' in onboarder.mapped_data:
                    summary_content += f"  • Documents: {len(onboarder.mapped_data['building_documents'])}\n"
            
            summary_content += "\n📁 GENERATED FILES:\n"
            
            # Check for generated files
            files_to_check = [
                ("migration.sql", "SQL Migration Script"),
                ("document_log.csv", "Document Metadata Log"),
                ("audit_log.json", "Processing Audit Log"),
                ("summary.json", "Processing Summary"),
                ("client-backup/", "Backup of Original Files")
            ]
            
            for filename, description in files_to_check:
                file_path = output_dir / filename
                if file_path.exists():
                    if file_path.is_file():
                        size = file_path.stat().st_size
                        summary_content += f"  ✅ {description}: {filename} ({size:,} bytes)\n"
                    else:
                        # Directory
                        file_count = len(list(file_path.rglob('*')))
                        summary_content += f"  ✅ {description}: {filename} ({file_count} files)\n"
                else:
                    summary_content += f"  ❌ {description}: {filename} (not found)\n"
            
            # Show first few lines of migration.sql
            migration_file = output_dir / "migration.sql"
            if migration_file.exists():
                summary_content += "\n📝 MIGRATION SQL PREVIEW:\n"
                summary_content += "=" * 50 + "\n"
                
                with open(migration_file, 'r') as f:
                    lines = f.readlines()
                    preview_lines = lines[:20]  # First 20 lines
                    summary_content += ''.join(preview_lines)
                    
                    if len(lines) > 20:
                        summary_content += f"\n... ({len(lines) - 20} more lines)\n"
            
            summary_content += "\n" + "=" * 50 + "\n"
            summary_content += "✅ Ready for Supabase import!\n\n"
            summary_content += "📁 OUTPUT LOCATION:\n"
            summary_content += f"   {output_dir.absolute()}\n\n"
            summary_content += "📋 Next steps:\n"
            summary_content += f"  1. Copy SQL from Results tab or open: {output_dir / 'migration.sql'}\n"
            summary_content += "  2. Execute SQL in Supabase SQL Editor\n"
            summary_content += "  3. Upload original documents directly to Supabase Storage\n"
            
            self.update_results(summary_content)
            
        except Exception as e:
            error_summary = f"Error generating results summary: {str(e)}"
            self.update_results(error_summary)


def main():
    """Main entry point"""
    root = tk.Tk()

    # Create and run app
    app = BlocIQOnboarderApp(root)
    
    try:
        root.mainloop()
    except KeyboardInterrupt:
        print("\nApplication interrupted by user")
        sys.exit(0)


if __name__ == "__main__":
    main()

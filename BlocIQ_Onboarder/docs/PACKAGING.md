# BlocIQ Onboarder - Desktop App Packaging Guide

This guide explains how to package the BlocIQ Onboarder Python application into a standalone Mac desktop application (.app file).

## Prerequisites

- Python 3.8+ installed
- All project dependencies installed
- PyInstaller installed

## Step 1: Install PyInstaller

```bash
pip install pyinstaller
```

## Step 2: Build the Desktop Application

Run the following command from the `BlocIQ_Onboarder` directory:

```bash
pyinstaller --onedir --windowed app.py --name BlocIQOnboarder
```

### Command Breakdown:
- `--onedir`: Creates a directory with the executable and dependencies (recommended for macOS .app bundles)
- `--windowed`: Hides the terminal window (GUI-only mode)
- `app.py`: The main Tkinter application entry point
- `--name BlocIQOnboarder`: Names the output application

**Note:** We use `--onedir` instead of `--onefile` because macOS .app bundles cannot be single files and this approach is more compatible with macOS security features.

### Alternative (Single File):
If you prefer a single executable file (not recommended for macOS), you can use:
```bash
pyinstaller --onefile --windowed app.py --name BlocIQOnboarder
```
However, this will create a single executable file instead of a proper .app bundle and may have security warnings on macOS.

## Step 3: Locate the Built Application

After the build completes, you'll find the application at:

```
dist/BlocIQOnboarder.app
```

## Step 4: Install to Applications (Optional)

To make the app easily accessible system-wide:

1. **Copy to Applications:**
   ```bash
   cp -r dist/BlocIQOnboarder.app /Applications/
   ```

2. **Or drag and drop:**
   - Open Finder
   - Navigate to `dist/BlocIQOnboarder.app`
   - Drag it to the Applications folder

## Step 5: Launch the Application

### From Applications Folder:
- Open Finder
- Go to Applications
- Double-click `BlocIQOnboarder.app`

### From Terminal:
```bash
open /Applications/BlocIQOnboarder.app
```

### From Finder (if in dist folder):
- Navigate to the `dist` folder
- Double-click `BlocIQOnboarder.app`

## Troubleshooting

### Build Issues:
- **Missing dependencies**: Ensure all requirements are installed with `pip install -r requirements.txt`
- **Import errors**: Check that all Python files are in the correct directory
- **Permission errors**: Run with `sudo` if needed (not recommended)

### Runtime Issues:
- **App won't start**: Check the console for error messages
- **Missing files**: Ensure the app is run from the correct directory
- **GUI not appearing**: Check that you're using `--windowed` flag

### File Size:
The resulting .app file will be large (100-200MB) because it includes:
- Python interpreter
- All dependencies (pandas, openpyxl, pdfplumber, etc.)
- Tkinter libraries
- All project files

This is normal for PyInstaller applications.

## Development vs Production

### Development:
- Use `python app.py` for quick testing
- Use `python launch.py` for dependency checking

### Production:
- Use the packaged `.app` file for distribution
- No Python installation required on target machines
- Self-contained and portable

## File Structure After Building

```
BlocIQ_Onboarder/
├── app.py                    # Source code
├── onboarder.py              # Source code
├── ...                       # Other source files
├── dist/
│   └── BlocIQOnboarder.app   # Built application
├── build/                    # Build artifacts (can be deleted)
└── BlocIQOnboarder.spec      # PyInstaller spec file
```

## Distribution

To distribute the app to other staff members:

1. **Zip the .app file:**
   ```bash
   cd dist
   zip -r BlocIQOnboarder.zip BlocIQOnboarder.app
   ```

2. **Share the zip file** with team members

3. **Recipients extract and install:**
   - Extract the zip file
   - Drag `BlocIQOnboarder.app` to Applications folder
   - Double-click to run

## Notes

- The app is completely self-contained
- No Python installation required on target machines
- All dependencies are bundled inside the .app
- The app can be run on any Mac (Intel or Apple Silicon)
- First launch may be slower due to code signing and security checks

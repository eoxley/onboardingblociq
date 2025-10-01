# -*- mode: python ; coding: utf-8 -*-


a = Analysis(
    ['onboarder.py'],
    pathex=[],
    binaries=[],
    datas=[],
    hiddenimports=[
        'docx', 'pdfplumber', 'pandas', 'PyPDF2', 'openpyxl',
        'pdfminer', 'pdfminer.six', 'pdfminer.layout', 'pdfminer.pdfpage',
        'pdfminer.pdfinterp', 'pdfminer.converter', 'pdfminer.pdfdocument',
        'PIL', 'PIL.Image', 'Pillow'
    ],
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[],
    noarchive=False,
    optimize=0,
)
pyz = PYZ(a.pure)

exe = EXE(
    pyz,
    a.scripts,
    a.binaries,
    a.datas,
    [],
    name='onboarder',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    upx_exclude=[],
    runtime_tmpdir=None,
    console=True,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
)

from PIL import Image, ImageDraw, ImageFont

# Create 512x512 icon
size = 512
img = Image.new('RGB', (size, size), '#2c5aa0')  # Blue background
draw = ImageDraw.Draw(img)

# Draw hammer emoji representation (simple geometric shape)
# Draw hammer head
draw.rectangle([150, 180, 280, 250], fill='#cccccc', outline='#888888', width=3)
# Draw hammer handle
draw.rectangle([190, 250, 240, 400], fill='#8B4513', outline='#654321', width=3)

# Add text
try:
    font_size = 48
    text = "Supplier\nOnboarding"
    draw.text((size//2, 430), text, fill='white', anchor='mm', align='center')
except:
    pass

img.save('/tmp/supplier_icon.png')
print("Icon created!")

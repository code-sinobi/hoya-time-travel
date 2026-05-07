import os
from PIL import Image

def optimize_images(directory):
    for root, _, files in os.walk(directory):
        for file in files:
            if file.lower().endswith(('.png', '.jpg', '.jpeg')):
                filepath = os.path.join(root, file)
                try:
                    with Image.open(filepath) as img:
                        # Convert RGBA to RGB if saving as JPEG
                        if file.lower().endswith(('.jpg', '.jpeg')) and img.mode == 'RGBA':
                            img = img.convert('RGB')
                        img.save(filepath, optimize=True, quality=85)
                        print(f"Optimized: {filepath}")
                except Exception as e:
                    print(f"Failed to optimize {filepath}: {e}")

if __name__ == "__main__":
    optimize_images('assets/images')

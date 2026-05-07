import os
import argparse
from PIL import Image

def optimize_images(directory):
    for root, _, files in os.walk(directory):
        for file in files:
            ext = file.lower()
            if ext.endswith(('.png', '.jpg', '.jpeg')):
                filepath = os.path.join(root, file)
                try:
                    with Image.open(filepath) as img:
                        img.load()  # Force full decode; closes PIL's internal fp before overwrite
                        if ext.endswith(('.jpg', '.jpeg')):
                            if img.mode == 'RGBA':
                                img = img.convert('RGB')
                            img.save(filepath, optimize=True, quality=85)
                        elif ext.endswith('.png'):
                            img.save(filepath, optimize=True, compress_level=9)
                        print(f"Optimized: {filepath}")
                except Exception as e:
                    print(f"Failed to optimize {filepath}: {e}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Optimize image assets.')
    parser.add_argument('directory', nargs='?', default='assets/images', help='Directory of images to optimize')
    args = parser.parse_args()
    optimize_images(args.directory)

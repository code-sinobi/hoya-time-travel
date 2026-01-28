import os
from PIL import Image

ASSETS_DIR = r'c:\hoya-app\assets'
MAX_DIMENSION = 1920
QUALITY = 80

def optimize_image(file_path):
    try:
        with Image.open(file_path) as img:
            # Skip strictly small images
            if os.path.getsize(file_path) < 500 * 1024: # Less than 500KB
                print(f"Skipping {file_path} (already small)")
                return

            # Resize if too big
            width, height = img.size
            if width > MAX_DIMENSION or height > MAX_DIMENSION:
                ratio = min(MAX_DIMENSION / width, MAX_DIMENSION / height)
                new_size = (int(width * ratio), int(height * ratio))
                img = img.resize(new_size, Image.Resampling.LANCZOS)
                print(f"Resized {file_path} from {width}x{height} to {new_size[0]}x{new_size[1]}")
            
            # Save nicely
            # Convert to RGB if RGBA (jpeg doesn't support alpha)
            if img.mode in ('RGBA', 'P') and file_path.lower().endswith(('.jpg', '.jpeg')):
                img = img.convert('RGB')

            img.save(file_path, optimize=True, quality=QUALITY)
            print(f"Optimized {file_path} -> {os.path.getsize(file_path) / 1024 / 1024:.2f} MB")
            
    except Exception as e:
        print(f"Error processing {file_path}: {e}")

def main():
    print(f"Scanning {ASSETS_DIR}...")
    for root, dirs, files in os.walk(ASSETS_DIR):
        for file in files:
            if file.lower().endswith(('.png', '.jpg', '.jpeg')):
                optimize_image(os.path.join(root, file))

if __name__ == "__main__":
    main()

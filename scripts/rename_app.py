import os
import re

def replace_in_file(filepath):
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
    except Exception as e:
        return False

    new_content = content
    # Order matters: replace longer strings first
    replacements = {
        'com.hoya.hoya_app': 'com.chrono.chrono_app',
        'hoya_app': 'chrono_app',
        'hoya-app': 'chrono-app',
        'Hoya App': 'Chrono App',
        'HoyaApp': 'ChronoApp',
        'Hoya': 'Chrono',
        'hoya': 'chrono'
    }
    
    for old, new in replacements.items():
        new_content = new_content.replace(old, new)
        
    if new_content != content:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(new_content)
        print(f"Updated: {filepath}")
        return True
    return False

def main():
    root_dir = r"c:\hoya-app"
    exclude_dirs = {'.git', '.dart_tool', 'build', 'windows', 'linux', 'macos', 'node_modules', '.idea', '.vscode'}
    exclude_extensions = {'.png', '.jpg', '.jpeg', '.gif', '.ico', '.ttf', '.mp4', '.mp3', '.pyc', '.pyo'}
    
    count = 0
    for dirpath, dirnames, filenames in os.walk(root_dir):
        # Modify dirnames in-place to skip excluded directories
        dirnames[:] = [d for d in dirnames if d not in exclude_dirs]
        
        for filename in filenames:
            ext = os.path.splitext(filename)[1].lower()
            if ext in exclude_extensions:
                continue
                
            filepath = os.path.join(dirpath, filename)
            if filepath.endswith('rename_app.py'):
                continue
                
            if replace_in_file(filepath):
                count += 1
                
    print(f"Total files updated: {count}")

if __name__ == '__main__':
    main()

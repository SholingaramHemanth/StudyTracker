import re

file_path = r'c:\Users\solin\Downloads\Hemanth_b_E309drGtPne-1773079189463\mobile_app\lib\main.dart'

with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
    content = f.read()

# Replace all emoji entries with simple ASCII markers to ensure no corruption
content = re.sub(r"'emoji': '[^']+'", "'emoji': 'Q'", content)

# Clean up any remaining non-ASCII blocks that look like corruptions
content = re.sub(r'[^\x00-\x7F]+', ' ', content)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)

print("Absolute ASCII cleanup done.")

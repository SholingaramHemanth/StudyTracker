import re

file_path = r'c:\Users\solin\Downloads\Hemanth_b_E309drGtPne-1773079189463\mobile_app\lib\main.dart'

with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
    content = f.read()

# Replace all emoji entries with simple strings to remove corruption
content = re.sub(r"'emoji': '[^']+'", "'emoji': '📝'", content)

# Also fix other common corruptions
replacements = {
    'â€“': '-',
    'âœ“': 'OK',
    'â€"': '-',
    'Ã‚Â²': '^2',
    'Â²': '^2',
    'âˆ«': '∫',
    'ðŸ“ ': '📐',
    'ðŸ”¢': '🔢',
    'ðŸ“Œ': '📌',
    'ðŸ”£': '🔣',
    'â­•': '⭕',
    'ðŸŒ€': '🌀',
    'â —': '❗',
    'ðŸ”µ': '🔵',
    'ðŸ”º': '🔺',
    'ðŸ“ˆ': '📈',
    'ðŸª™': '🪙',
    'ðŸ”±': '🔱',
    'ðŸ’»': '💻',
    'ðŸ“Š': '📊',
    'â¬¡': '⬡',
    'ðŸ”²': '🔲',
    'âš¡': '⚡',
}

for old, new in replacements.items():
    content = content.replace(old, new)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)

print("Emoji cleanup and safe replacement done.")

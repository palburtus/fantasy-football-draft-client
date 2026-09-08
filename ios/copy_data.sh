#!/bin/bash

# Copy data files from React project to iOS project
# Usage: ./copy_data.sh

SOURCE_DIR="../src"
DEST_DIR="FantasyFootballDraft/FantasyFootballDraft/"

echo "📋 Copying data files from React project to iOS app..."

# Copy all data_*.json files
for file in $SOURCE_DIR/data_*.json; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        cp "$file" "$DEST_DIR"
        echo "✅ Copied $filename"
    fi
done

echo ""
echo "✨ Done! Data files are now in the iOS project."
echo ""
echo "Next steps in Xcode:"
echo "1. In Project Navigator, right-click FantasyFootballDraft folder"
echo "2. Select 'Add Files to \"FantasyFootballDraft\"'"
echo "3. Select all copied data_*.json files"
echo "4. ✅ Check 'Copy items if needed'"
echo "5. ✅ Add to target 'FantasyFootballDraft'"

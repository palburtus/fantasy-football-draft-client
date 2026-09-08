#!/bin/bash

# Make copy_data.sh executable
chmod +x copy_data.sh

# Make sure paths exist
mkdir -p FantasyFootballDraft/FantasyFootballDraft

echo "✅ iOS project initialized!"
echo ""
echo "Next steps:"
echo "1. cd FantasyFootballDraft"
echo "2. pod install"
echo "3. open FantasyFootballDraft.xcworkspace"
echo "4. Set up Firebase GoogleService-Info.plist"
echo "5. Run copy_data.sh to add player data"
echo ""
echo "Full instructions: See SETUP_GUIDE.md"

# iOS Build Setup Guide

This document provides step-by-step instructions to get the native iOS app running on an iPad.

## Quick Start (5 minutes)

### 1. Install Pods
```bash
cd ios/FantasyFootballDraft
pod install
```

### 2. Open Workspace
```bash
open FantasyFootballDraft.xcworkspace
```

### 3. Configure Signing
- In Xcode, select the `FantasyFootballDraft` target
- Go to Signing & Capabilities
- Select your Team

### 4. Run
- Select an iPad simulator or device
- Press Cmd+R to build and run

## Detailed Setup

### Step 1: Verify Xcode Installation

```bash
xcode-select --install
```

### Step 2: Install CocoaPods

```bash
sudo gem install cocoapods
```

### Step 3: Setup Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Create new project: "Fantasy Football Draft"
3. Add iOS app:
   - Bundle ID: `com.yourcompany.FantasyFootballDraft`
   - App Store ID: (leave blank for now)
   - Team ID: (your team ID)
4. Download GoogleService-Info.plist
5. Drag into Xcode project (select "Copy items if needed")

### Step 4: Install Dependencies

```bash
cd ios/FantasyFootballDraft
pod install
```

Wait for installation to complete. You should see:
```
Pod installation complete! There are X dependencies from the Podfile.
```

### Step 5: Add Data Files

Copy the data JSON files to the project:

```bash
cp src/data_*.json ios/FantasyFootballDraft/FantasyFootballDraft/
```

In Xcode:
1. Select FantasyFootballDraft folder in Project Navigator
2. Right-click → Add Files to "FantasyFootballDraft"
3. Select data_*.json files
4. ✅ "Copy items if needed"
5. ✅ Add to target "FantasyFootballDraft"

### Step 6: Build Settings

In Xcode:
1. Select target `FantasyFootballDraft`
2. Build Settings
3. Search for "Minimum Deployments"
4. Set to iOS 15.0

### Step 7: Build & Run

```bash
# In Xcode
Cmd+B  # Build
Cmd+R  # Run on selected simulator/device
```

## Device Deployment

### To Device

1. Plug in iPad
2. Xcode auto-detects it
3. Select device in scheme selector
4. Cmd+R to deploy

### Requirements

- iPad with iOS 15.0 or later
- Apple Developer Account (free for development)
- Provisioning profile (auto-managed by Xcode)

## Testing the App

### Test Data Loading
- App opens with 2026 season data
- Player list should populate immediately
- No Firebase errors in console

### Test Search & Filters
- Search: Type player name → list filters
- Position: Select "QB" → shows only QBs
- Available: Toggle → shows only undrafted players

### Test Notes
- Tap player → Detail view opens
- Click pencil icon → Note editor appears
- Write note → Save
- Return to list → Player shows note indicator

## Troubleshooting

### Build Fails: "No such module Firebase"

```bash
# Clean and retry pods
cd ios/FantasyFootballDraft
rm -rf Pods Podfile.lock
pod install
```

### App Crashes on Launch

Check Xcode console for errors:
- Firebase config missing → Add GoogleService-Info.plist
- Data file not found → Verify in Build Phases > Copy Bundle Resources
- Invalid JSON → Check data_*.json format

### iPad Shows Only Portrait

Check Info.plist:
- `UIDeviceFamily` should be `2` (iPad only)
- `UISupportedInterfaceOrientations~ipad` should have all 4 orientations

## Advanced Configuration

### Change Firebase Project

Edit `GoogleService-Info.plist`:
```xml
<key>PROJECT_ID</key>
<string>your-new-project-id</string>
```

### Change Bundle Identifier

In Xcode:
1. Select target
2. General tab
3. Update "Bundle Identifier"
4. Must match Firebase console app registration

### Disable Analytics

In `FantasyFootballDraftApp.swift`:
```swift
// Comment out analytics if not needed
// getAnalytics(app: FirebaseApp.app()!)
```

## Next Steps

1. ✅ App builds and runs
2. 📊 Verify data loads correctly
3. 📝 Test note saving with Firebase
4. 🎯 Customize colors/theming as desired
5. 🚀 Submit to App Store (future)

## Support

For issues:
1. Check Xcode build log (Cmd+Shift+K)
2. Check console output (Cmd+Shift+C)
3. Verify all configuration steps above
4. Check Firebase project settings

## File Locations

After setup, your project structure should look like:

```
ios/FantasyFootballDraft/
├── FantasyFootballDraft.xcworkspace  ← OPEN THIS
├── FantasyFootballDraft/
│   ├── data_2020.json
│   ├── data_2021.json
│   ├── ...
│   ├── GoogleService-Info.plist
│   └── [all Swift source files]
└── Pods/
    └── [dependencies]
```

Always open `.xcworkspace`, not `.xcodeproj`!

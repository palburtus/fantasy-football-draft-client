# Fantasy Football Draft - Native iOS App

A native SwiftUI app for iPad designed to help manage fantasy football drafts with comprehensive player statistics, notes, and multi-year comparison.

## Features

- **iPad-Optimized UI**: Built specifically for iPad with NavigationSplitView for side-by-side master-detail layout
- **Player Database**: Access comprehensive player stats including ADP, air yards, WOPR, rushing stats, and TDs
- **Multi-Year Support**: Compare players across seasons (2020-2026)
- **Filtering & Search**: Filter by position, search by player name or NFL team
- **Draft Tracking**: Mark players as drafted/available
- **Notes & Tagging**: Add detailed notes to players with color-coded tags:
  - Target, Value, 2nd-Year, 3rd-Year, Servicable, Upside
  - Rookie, Price has to be Right, High-Floor/Low Ceiling
  - Limited Upside, TD Regression, Lottery Ticket, Handcuff, Reach, Avoid
- **Firebase Integration**: Sync notes across devices using Firestore
- **Dark Mode**: Optimized dark interface

## Project Structure

```
ios/FantasyFootballDraft/
├── FantasyFootballDraft/
│   ├── Models/
│   │   └── Player.swift           # Player data model with Codable
│   ├── Views/
│   │   ├── ContentView.swift      # Main iPad split view
│   │   ├── PlayerRowView.swift    # Player list item view
│   │   └── PlayerDetailView.swift # Player detail & notes editing
│   ├── Managers/
│   │   └── DraftDataManager.swift # Data loading & filtering
│   ├── Repositories/
│   │   └── NotesRepository.swift  # Firebase Firestore integration
│   ├── FantasyFootballDraftApp.swift
│   ├── Info.plist                 # App configuration (iPad-only)
│   └── GoogleService-Info.plist   # Firebase configuration (template)
├── Podfile                        # CocoaPods dependencies
└── README.md                      # This file
```

## Setup Instructions

### 1. Prerequisites
- Xcode 14.0 or later
- iOS 15.0+ deployment target
- CocoaPods installed
- Firebase account with a Firestore database

### 2. Install Dependencies

```bash
cd ios/FantasyFootballDraft
pod install
```

### 3. Configure Firebase

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Create a new project or select existing
3. Add an iOS app with bundle ID: `com.yourcompany.FantasyFootballDraft`
4. Download `GoogleService-Info.plist`
5. Replace the template `GoogleService-Info.plist` in the Xcode project

### 4. Add Player Data

Copy your data JSON files to the Xcode project:

```bash
cp ../src/data_*.json FantasyFootballDraft/
```

Make sure to add these files to the Xcode target in Build Phases > Copy Bundle Resources.

### 5. Configure App Settings

In Xcode:
1. Select `FantasyFootballDraft` target
2. Go to Signing & Capabilities
3. Set Team ID for code signing
4. Update Bundle Identifier if needed

### 6. Build & Run

```bash
# Open workspace (not xcodeproj)
open FantasyFootballDraft.xcworkspace

# In Xcode: Select iPad simulator/device and Run (Cmd+R)
```

## Data Format

Player JSON format (matching existing data_YYYY.json):

```json
{
  "player_name": "Patrick Mahomes",
  "position": "QB",
  "nfl_team": "KC",
  "adp": 5.2,
  "air_yards": 0,
  "wopr": 0,
  "rush_attempts": 12,
  "yards_per_carry": 4.2,
  "TDs": 24,
  "age": 28
}
```

## Firebase Firestore Structure

Notes are stored in Firestore with the following document structure:

```
Collection: notes
Document ID: {year}_{playerName}
Fields:
- playerName: String
- note: String
- tags: Array<String>
- year: Int
- timestamp: Timestamp
```

## Architecture

### MVVM Pattern
- **Models**: `Player`, `PlayerNote` - Data structures
- **ViewModels**: `DraftDataManager`, `NotesRepository` - Business logic & state
- **Views**: SwiftUI views with `@StateObject` & `@State` for state management

### Key Components

**DraftDataManager**
- Loads player data from JSON files
- Filters players by position, availability, search term
- Sorts by ADP
- Manages drafted/available player state

**NotesRepository**
- Firebase Firestore integration
- Load/save/delete player notes
- Persists user annotations and tags

**ContentView**
- NavigationSplitView for iPad master-detail
- Year selector (segmented control for 5 years)
- Position filter with menu
- Availability toggle
- Search bar with real-time filtering

## iPad Optimizations

- **NavigationSplitView**: Master (filters) + Content (player list) + Detail (player info)
- **Landscape Support**: Maintains split view in all orientations
- **Touch Friendly**: Larger tap targets, optimized spacing
- **Split View Navigation**: Select players from list to show details
- **Device Detection**: App runs only on iPad (UIDeviceFamily: 2)

## Future Enhancements

- [ ] Sync draft with league API
- [ ] Real-time collaboration during live draft
- [ ] Historical player comparison charts
- [ ] Custom ranking lists
- [ ] Draft simulator/tools
- [ ] Player recommendation engine
- [ ] Offline mode with local sync
- [ ] Watch app companion

## Configuration Notes

### iPad-Only Build
The app is configured to run on iPad only through Info.plist:
```xml
<key>UIDeviceFamily</key>
<array>
	<integer>2</integer>
</array>
```

### Deployment Target
- Minimum: iOS 15.0 (SwiftUI requirements)
- Target: iPad Air 2 or newer

## Troubleshooting

**Firebase Not Connecting**
- Verify GoogleService-Info.plist is added to target
- Check Firebase project rules allow reads/writes for your user
- Review console logs for auth errors

**Data Not Loading**
- Ensure data_YYYY.json files are in Bundle Resources
- Check JSON format matches Player model
- Look for decode errors in console

**Notes Not Saving**
- Verify Firestore is enabled in Firebase Console
- Check user is authenticated
- Review Firestore security rules

## License

Proprietary - Fantasy Football Draft Client

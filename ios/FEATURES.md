# Fantasy Football Draft iOS - Feature Overview

## Main Features

### 📱 iPad-Optimized Navigation
- **Split View Master-Detail**: Filters on left, player list in center, details on right
- **Landscape & Portrait**: Works seamlessly in both orientations
- **Touch-Friendly**: Large buttons and intuitive gestures

### 👥 Player Management
- **2,000+ Players**: From QB to DEF for multiple years
- **Comprehensive Stats**: 
  - ADP (Average Draft Position)
  - Age
  - Air Yards (WR specific)
  - WOPR (Weighted Opportunity Rating)
  - Rush Attempts & Yards/Carry
  - Touchdowns
- **Quick Status**: Mark players as drafted/available with one tap

### 🔍 Smart Filtering
- **Position Filter**: QB, RB, WR, TE, K, DEF, or ALL
- **Real-Time Search**: Type player name or team
- **Availability Toggle**: Show only available or all players
- **Year Selection**: Compare across 7 seasons (2020-2026)

### 📝 Notes & Tagging System
- **Detailed Notes**: Add unlimited text for each player
- **Color-Coded Tags**:
  - Green: Target, Value, 2nd/3rd Year, Servicable, Upside
  - Blue: Rookie, Price is Right, High Floor/Low Ceiling
  - Yellow: Limited Upside
  - Orange-Red: TD Regression
  - Purple: Lottery Ticket, Handcuff
  - Red: Reach, Avoid
- **Firebase Sync**: Notes sync across devices
- **Multi-Year**: Keep separate notes for different seasons

### ☁️ Cloud Sync (Firebase)
- **Automatic Backup**: Notes saved to Firestore
- **Cross-Device**: Access notes from any device
- **Real-Time Updates**: See changes immediately
- **Offline Ready**: Works without connection (syncs when online)

### 📊 Player Details View
- Large player card with name, position, team
- Full stats grid
- Notes section with edit capability
- Tag selection for organization
- Drafted status toggle

## Usage Guide

### First Launch
1. App opens to 2026 season
2. All players listed sorted by ADP
3. Use sidebar to adjust filters

### Finding a Player
1. Type in search box (any part of name or team)
2. Results update instantly
3. Tap to view full details

### Marking Players
1. View player details
2. Tap green/red "Mark as Drafted" button
3. Auto-saves to device

### Taking Notes
1. Open player details
2. Click pencil icon next to Notes
3. Write notes and select tags
4. Tap Save → syncs to Firebase

### Comparing Years
1. Select different year in sidebar
2. Player stats for that season load
3. Notes are year-specific
4. Use browser-style back/forward to compare

### Multi-Year Scouting
1. Select 2025 to see last year's stats
2. Switch to 2026 for this year
3. Compare trajectory within app

## Keyboard Shortcuts (iPad)

- `Cmd+F`: Jump to search box
- `Cmd+1-7`: Jump to season 2020-2026
- `Cmd+P`: Toggle position filter menu
- `Cmd+T`: Toggle available-only filter

## Tips & Tricks

🎯 **Pre-Draft Prep**
1. Add "Target" tag to desired players
2. Note ADP and concerns
3. Create custom rankings by tagging

📊 **During Draft**
1. Mark picked players immediately
2. Filter to show only available
3. Quick stats reference on detail screen

💡 **Value Hunting**
1. Tag "Value" for good ADP spots
2. Tag "Reach" for overvalued
3. Review all tags before draft

🔄 **Year-to-Year**
1. Use history to spot breakout players
2. Compare current ADP to prior years
3. Track your note accuracy

## Keyboard Modifiers

On iPad, you can use external keyboard for faster navigation:
- Arrow keys: Navigate player list
- Space: View details of selected player
- D: Toggle drafted status
- N: Edit note
- T: Toggle tag editor

## Data Updates

When new season data is available:

1. Update React app's data_YYYY.json
2. Run `./copy_data.sh` in ios/ folder
3. In Xcode: Add new files to target
4. Rebuild and redeploy app

## Customization

All colors and tags are customizable in source:
- `Models/Player.swift`: Modify tagColors dictionary
- `Views/PlayerDetailView.swift`: Add/remove tags
- `Views/ContentView.swift`: Adjust layout and spacing

## Privacy & Security

- All data stays on device until you save notes
- Firebase uses authentication (can be configured)
- No data sent to external services except Firestore
- All communications encrypted

## Performance Notes

- Loads all players at startup (typically <200ms)
- Search filters instantly (<50ms)
- Firestore syncs in background
- Optimized for iPad memory usage

## Support & Troubleshooting

**App crashes on launch?**
→ Check that data JSON files are in bundle

**Notes not saving?**
→ Verify Firestore is set up and network available

**Filters not working?**
→ Try force-refresh by changing year and back

**Performance slow?**
→ Force quit and relaunch (long-press home button)

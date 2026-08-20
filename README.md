# Football Setup

### Step 1: Compiling Data
- Rotoworld / NBCSports Rankings
- Rotoworld / NBCSports ADP
- Air Yarks from https://ftnfantasy.com/nfl/air-yards?fppg=PPR&positions=WR&years=2023
- copy draft from EPSN fantasy league page
- update local file path names in script
- manualy create the keepers file
- run the main.py file in the football folder

### Step 2: Run Fantasy Draft Client 2
- The current working dataset is registered as the 2025 season in `src/yearData.js` and is stored in `src/data_2025.json`.
- To import 2026 data, replace the contents of `src/data_2026.json` with the generated JSON array. Keep the existing field names, including `player_name`, `position`, `nfl_team`, `adp`, `air_yards`, `wopr`, `rush_attempts`, `yards_per_carry`, and `TDs`.
- The application opens on the 2026 view. Use the Draft year selector to switch to 2025 and look up that player's prior-year stats and notes.
- Notes are stored in Firebase with the year and player name. Existing notes without a year are treated as 2025 notes for backward compatibility; new notes are kept separate between seasons.

### Step 3: Compile a New Season with Claude
- Use the repository skill at `.claude/skills/fantasy-football-data/SKILL.md` when refreshing or creating a yearly dataset.
- Ask Claude to validate the source CSV headers, malformed preambles, line endings, duplicate names, and player match counts before applying data.
- The skill documents the source mappings for rankings, ESPN ADP, Air Yards/WOPR, rushing, and touchdowns, including which fields may be imported and when missing players require approval.
- Player ages are calculated from nflverse `birth_date` values using a fixed reference date, with unresolved names left blank for review.
- Exact player-name matches are applied automatically. Ambiguous associations and qualifying missing players are presented one at a time with add, skip, or associate options, along with the automatic-update count.
- After importing, run `CI=true npm test -- --watchAll=false --runInBand` and `npm run build`.


This project was bootstrapped with [Create React App](https://github.com/facebook/create-react-app).


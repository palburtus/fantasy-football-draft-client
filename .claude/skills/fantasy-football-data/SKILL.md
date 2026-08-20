---
name: fantasy-football-data
description: "Use when compiling or refreshing fantasy football yearly datasets from rankings, ADP, air-yards, rushing, or stats CSV files; validating source schemas and player matches; applying fields to src/data_YEAR.json; or handling missing/ambiguous players with approval rules."
---

# Fantasy Football Data Compilation

Use this workflow when creating the next season's dataset for `fantasy-football-draft-client`.

## Dataset contract

The app dataset lives at `src/data_YEAR.json` and is registered in `src/yearData.js`. Keep the existing player object shape:

- `player_name`
- `nfl_team`
- `position`
- `adp`
- `cost`
- `drafted_by`
- `is_YEAR_keeper`
- `air_yards`
- `wopr`
- `rush_attempts`
- `yards_per_carry`
- `TDs`
- `age`
- `is_available`

The current-year rankings file defines display order. Historical datasets are displayed in current-year order, while their rank number remains the historical rank from that year's source list. Do not use filtered row indexes as player ranks.

## Source mapping

For a new year, expect these source files under `data/`:

1. `fantasy_football_rankings_YEAR.csv`
   - Use only `Player`, `Team`, and `Position` to create the player list.
   - Preserve CSV row order as the current-year ranking order.
   - Map to `player_name`, `nfl_team`, and `position`.
   - Initialize all other fields with neutral defaults. Do not import expert rankings, tiers, bye weeks, or consensus columns unless explicitly requested.

2. `fantasy_football_adps_YEAR.csv`
   - Match by exact `Player` name.
   - Use only `ESPN` for `adp`.
   - Strip parenthetical movement: `2.60 (0.10)` becomes numeric `2.6`.
   - Report unmatched current-list players; leave their ADP blank rather than guessing.

3. `fantasy_football_airyards_YEAR.csv`
   - Match the CSV `Name` field to the existing `player_name`.
   - Apply only `Air Yds` to `air_yards` and `WOPR` to `wopr`.
   - Never add CSV-only players automatically.
   - Ask about a CSV-only player only when total air yards are greater than 400.
   - Prompt one player at a time with add, skip, or associate-with-existing-player options.

4. `fantasy_football_rushing_YEAR.csv`
   - Apply `Rush Yds` to the app's `rush_attempts` field, which is displayed as Rush Yards.
   - Apply `Rush Y/A` to `yards_per_carry`.
   - Exact name matches are automatic and never require prompting.
   - For non-exact names, use first-initial/last-name matching only when unambiguous; otherwise prompt for association.
   - Do not prompt for CSV-only players unless `Rush Yds` is greater than 400. Silently skip lower-yardage missing players.
   - Prompts must offer add, skip, or associate-with-existing-player.

5. `fantasy_football_stats_YEAR.csv`
   - Use the player table's `Rush TD` and `Rec TD` columns.
   - Set `TDs` to `Rush TD + Rec TD`.
   - Exact names are automatic and never require prompting.
   - Normalize embedded status, position, and team tokens only for matching; do not store those tokens in the player name.
   - For missing or uncertain players, prompt one at a time with add, skip, or associate options, and report the automatic-update count before every prompt.

6. nflverse `players.csv` release
   - Use the public nflverse players release for `display_name` and `birth_date`.
   - Match exact names first, then unique suffix-normalized names such as `Brian Thomas` to `Brian Thomas Jr.`.
   - Calculate completed age as of the explicitly chosen reference date; for the 2026 dataset use `2026-08-20`.
   - Add only the calculated `age` field. Do not rename players or overwrite existing fields.
   - Leave age blank for unresolved or ambiguous names and report them; never guess from team or position.

## Validation gates

Before writing any dataset:

1. Confirm every source file exists and report its byte size.
2. Read headers and verify required columns. Some exports have malformed preambles or CRLF line endings; normalize in memory only and never overwrite the source CSV.
3. Confirm the rankings file has no blank `Player`, `Team`, or `Position` values without explicitly reporting how blanks will be handled.
4. Check duplicate source player names and duplicate current-list names.
5. Check match counts by category: exact, normalized/confident, ambiguous, missing.
6. Never silently add a player. Apply automatic updates only to exact or explicitly approved associations.
7. Preserve existing fields when applying a single source. A rushing import must not change ADP, Air Yards, WOPR, or TDs.
8. Validate after writing:
   - JSON parses.
   - Player count is expected.
   - All ranking names remain in source order.
   - Applied numeric fields contain valid numeric values or intentional blanks.
   - No duplicate `player_name` values were introduced.
   - Representative rows prove parenthetical ADP stripping and each stat mapping.
9. Run `CI=true npm test -- --watchAll=false --runInBand` and `npm run build`.

## Safe import procedure

1. Inspect the current `src/data_YEAR.json` before editing; user changes may be present.
2. Build an in-memory lookup for each source and produce a match report before applying values.
3. Apply automatic exact matches in a single focused edit or data transformation.
4. Report the number of players updated automatically before any manual prompt.
5. Handle approvals one at a time. Record the chosen source-to-player association, then continue.
6. Re-run validation after each approved addition or association.
7. Update `src/yearData.js` and README instructions when a new year is introduced.

## Important name-handling rules

- Prefer exact names.
- Do not infer identity from team alone.
- A suffix such as `Jr.`, `III`, or `Sr.` may be an intentional name difference; prompt before associating unless the user has explicitly supplied the association.
- First-initial/last-name matching is allowed for the rushing source only when it yields one unambiguous current-list player.
- Preserve the app's existing player name when associating source stats to an existing record.
- Keep an audit summary: source rows, automatic updates, approved additions, skipped rows, unresolved rows, and duplicate/malformed rows.

## Example invocation

Ask the assistant to:

> Compile the 2027 fantasy dataset from the files in `data/`. Validate all source columns and matches, apply exact matches automatically, and prompt me only for missing or ambiguous players under the rules in the fantasy football data skill.

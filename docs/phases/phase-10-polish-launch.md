# Phase 10 — Polish & launch (M3)

**Goal:** Greenrune 1.0 is balanced, readable, bug-free on the main paths, and released.

**Phase 10 is complete when (Greenrune 1.0):**
- 1.0 is downloadable on Windows and macOS.
- No known progression blocker remains, and saves from every version load.
- A full in-game day can be played with only a controller on a TV, with all text readable from 2 m.
- Everything in the [1.0 scope table](../endgame.md#scope-targets) is in the game.

**Starts when:** [Phase 9](phase-09-story-late-game.md) is done.

**Steps:**
1. **Balance pass.** Write a script that exports all data resources to CSV; review the curves (RP costs vs refills, skill XP, prices, drop rates, taming odds); fix outliers in data, not code.
2. **UI and controls.** Controller support in every menu; remappable keys; a text-size option; every menu reachable in ≤2 screens.
3. **Audio.** Music per season and per area (CC0 or commissioned); an audit list of every player action and its sound.
4. **Bugs, events, saves.** An event audit giving every event a guaranteed trigger path; one save from every save version (v1–v9) kept in a test folder.
5. **First-hour pass.** 3 new players play the first hour; fix the top confusion points.
6. **Launch.** Windows and macOS builds; a trailer and store page; a launch-day checklist (builds uploaded, page live, known-issues list); a post-launch patch plan for the first 2 weeks.

**Checklist:**
- [ ] A new game's first Spring logs no price, drop rate or XP gain the CSV review marked as an outlier
- [ ] Every menu works with a controller alone, keys can be remapped, and no menu is deeper than 2 screens
- [ ] At the default text size, all text reads at 1080p from 2 m
- [ ] Every action on the audit list plays a sound, and each season and area has music
- [ ] Every save in the test folder (v1–v9) loads into the final version
- [ ] No event soft-locks when triggered out of its usual order
- [ ] All 3 new players reach every core system within 2 hours without help
- [ ] The Windows and macOS builds run on machines that aren't yours

**Out of scope for this phase:** everything in [endgame.md › Not in 1.0](../endgame.md#not-in-10).

**Reference:** [research › Criticism](../rf4-research.md#criticism-from-critics-and-players) (UI, tutorial, event bugs).

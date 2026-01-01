# NoSoliciting - Turtle WoW Chat Filter

A lightweight addon for Turtle WoW that filters unwanted messages from chat channels by hiding messages containing specific keywords.

## Features

- **Hides messages** containing keywords (not just shows them)
- **Filters multiple channels**: World, Trade, Say, Yell, and all joined channels
- **Case-insensitive keyword matching** (e.g., "lfw" filters "LFW", "Lfw", etc.)
- **Automatic channel tracking** - updates when you join/leave channels
- **Quote support** for keywords with spaces
- **Simple slash commands** for easy management
- **Per-character settings** - each character has its own filter list

## Installation

1. Download the addon files
2. Extract to your WoW addons folder: `World of Warcraft\_classic_\Interface\AddOns\`
3. Create a folder named `NoSoliciting`
4. Place these files inside:
   - `NoSoliciting.toc`
   - `NoSoliciting.xml`
   - `NoSoliciting.lua`
5. Restart WoW or type `/reload` in-game

## Usage

### Basic Commands
- `/ns` or `/nosoliciting` - Show help
- `/ns add <keyword>` - Add a keyword to filter
- `/ns del <keyword>` - Remove a keyword from filter
- `/ns list` - Show current filter list
- `/ns on` - Enable filtering
- `/ns off` - Disable filtering
- `/ns channels` - Show which channels are being filtered
- `/ns refresh` - Manually refresh joined channels list
- `/ns test` - Run a test to verify filtering works

### Keyword Examples
- `/ns add lfw` - Filter trade skill spam eg: "ENCHANTER LFW BLAH BLAH"
- `/ns add " hr"` - Filter " hr" as a standalone word (with spaces) eg: "LFM BRD HOJ HR NEED HEALS"

### Filtered Channels
- World Channel
- Trade Channel
- Say (/s) Channel
- Yell (/y) Channel
- All other joined channels (General, LocalDefense, LFG, etc.)

## Tips & Tricks

### Effective Keyword Suggestions
To filter common spam:
summon, lfg, lfw, " hr", recruiting

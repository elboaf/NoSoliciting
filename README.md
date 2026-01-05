
**Note**: Lines starting with `#` are treated as comments and ignored during import.

## Filtered Channels
The addon automatically filters messages in:
- **Always filtered**: World, Trade, Say, Yell
- **Dynamic filtering**: All channels you have joined (General, LocalDefense, LookingForGroup, etc.)

## Tips & Tricks
1. **Use quotes for phrases**: `/ns add "looking for group"` to filter the entire phrase
2. **Case doesn't matter**: "GOLD", "Gold", and "gold" are all caught
3. **Test your filters**: Use `/ns test` to verify filtering is working
4. **Share filters**: Export your list and share with friends
5. **Temporary disable**: Use `/ns off` to temporarily see all messages
6. **Refresh channels**: If you join a new channel, use `/ns refresh` to include it in filtering

## Troubleshooting
**Problem**: Keywords not being filtered
- **Solution**: Check if filtering is enabled with `/ns on`
- **Solution**: Verify the channel is being filtered with `/ns channels`

**Problem**: Import/Export not working
- **Solution**: Ensure you have SuperWoW.dll installed
- **Solution**: Check file exists in `WoW\imports\` folder

**Problem**: Addon not loading
- **Solution**: Verify `NoSoliciting.toc` file exists and contains correct interface version

## Compatibility
- **Client**: Turtle WoW (Vanilla 1.12)
- **Lua Version**: 5.0
- **SuperWoW.dll**: Required for import/export functionality

## Changelog
**v1.0** - Initial Release
- Basic keyword filtering
- Channel detection for World, Trade, Say, Yell, and joined channels
- Import/Export functionality with SuperWoW support
- Slash command interface

## Credits
Developed for Turtle WoW community. Uses SuperWoW.dll functions for enhanced functionality.

## Support
For issues or suggestions, please report on the Turtle WoW addons forum or GitHub repository.

---

**Note**: This addon is designed specifically for Turtle WoW and may not work on other private servers due to SuperWoW.dll dependency for import/export features.

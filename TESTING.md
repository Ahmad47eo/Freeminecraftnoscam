# Testing Status

## Current status

The project has a test target for the launcher foundation.

### Automated tests

- Default launcher instance starts in **Needs Import** state.
- Importing an instance adds it with the selected name, version, and loader.
- Imported instances are marked **Ready** by the current foundation.

## NOT DONE YET

These are intentionally still marked as not done because they require the real iOS implementation and device testing:

- [ ] Files app Minecraft-version importer
- [ ] Real JAR/ZIP scanner
- [ ] Fabric/Forge/NeoForge metadata parser
- [ ] Dependency resolver
- [ ] Per-instance mod enable/disable
- [ ] Real Minecraft game/runtime integration
- [ ] Java runtime on iOS
- [ ] Touch controls wired to gameplay
- [ ] Controller input wired to gameplay
- [ ] Keyboard/mouse input wired to gameplay
- [ ] Real compatibility checks
- [ ] Crash-log collection from the game runtime
- [ ] Elevator-mod end-to-end test
- [ ] iPhone/iPad device test
- [ ] Release IPA/archive signing

The UI currently contains placeholders for these systems; they should not be reported as completed until they are implemented and tested.

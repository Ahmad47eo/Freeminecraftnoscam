# FreeMinecraftNoScam

An iOS/iPadOS Minecraft Java launcher foundation focused on locally imported game versions and mods.

## Goals
- Import locally stored Minecraft version files
- Detect Minecraft versions and Java mod loaders
- Manage separate instances
- Import and validate Fabric/Forge/NeoForge mods
- Touch, keyboard, mouse, and controller friendly UI
- Performance profiles for iPhone/iPad
- Compatibility checks before launch
- Crash/log diagnostics
- Dedicated elevator-mod profile support
- Keep game acquisition separate from the launcher: the app does not download or distribute pirated game copies

## Architecture
1. SwiftUI launcher UI
2. Import/instance manager
3. Mod and dependency scanner
4. Compatibility engine
5. Runtime bridge
6. Graphics/input backend
7. Diagnostics

The runtime bridge is a placeholder for a properly licensed Java/LWJGL-on-iOS backend.

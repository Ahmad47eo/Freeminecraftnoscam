# Ultimate Starter Chest

A small Horizon 26.3 native mod source bundle for the Horizon launcher.

## Command

In a world, run:

`/starterchest`

It adds a survival-friendly starter kit directly to the player's inventory: protective gear, basic mining gear, food, building blocks, light, and utility items. It includes a chest item too.

If the inventory is full, items that do not fit are reported rather than dropped.

## Build

The GitHub Actions workflow packages this source into a `.hnmod` artifact. The artifact is a source bundle; Horizon Launcher compiles native mods for the installed game when the player installs/builds it.

## Scope of this first version

The first version uses Horizon's plain-item inventory helper. That helper does not attach enchantments or custom item components, so this version does not claim to provide level-255 enchantments or custom-filled chest contents.

Native mods run with the game's user permissions and are not sandboxed. Review the source before installing and only install mods you trust.

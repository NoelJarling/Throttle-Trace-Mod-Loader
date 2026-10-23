# Throttle Trace Mod Loader

A minimal, unofficial mod loader for [Throttle Trace](https://store.steampowered.com/app/4535730/). The game has no built-in mod support, so this loader is started by Godot through `override.cfg` and loads every mod in the game's `mods/` folder.

Mods that use it:

- [Throttle Trace Rivals](https://github.com/NoelJarling/Throttle-Trace-Rivals): race your friends' personal-best ghosts in Time Attack
- [Throttle Trace Telemetry](https://github.com/NoelJarling/Throttle-Trace-Telemetry): record your laps and compare them in the browser

Built for Throttle Trace v0.40.0 (Godot 4.6). Game updates may break it.

## Install

### 1. Copy `override.cfg` into the game folder

In Steam: right-click Throttle Trace → **Manage → Browse local files**. Put `override.cfg` next to the game executable.

| OS      | Default game folder                                         |
|---------|-------------------------------------------------------------|
| Linux   | `~/.local/share/Steam/steamapps/common/Throttle Trace/`     |
| Windows | `C:\Program Files (x86)\Steam\steamapps\common\Throttle Trace\` |

### 2. Copy `mod_loader/` into the game's user data folder

| OS      | User data folder                                    |
|---------|-----------------------------------------------------|
| Linux   | `~/.local/share/godot/app_userdata/Throttle Trace/` |
| Windows | `%APPDATA%\Godot\app_userdata\Throttle Trace\`      |

The folder exists once you have started the game at least once. Mods go into a `mods/` folder next to `mod_loader/`, one folder per mod:

```
Throttle Trace/            (user data folder)
├── mod_loader/
│   └── mod_loader.gd
└── mods/                  (created by the loader on first start)
    └── <mod name>/
        └── mod.gd
```

### 3. Enable mods in the Steam launch options

Mods are only loaded when the game is started with `--enable-mods`. In Steam: right-click Throttle Trace → **Properties → General → Launch Options** and enter:

```
%command% --enable-mods
```

Without this option the game runs completely unmodded, even with everything installed.

## Uninstall

To play without mods, just remove `--enable-mods` from the launch options.

To uninstall, delete `override.cfg` from the game folder. To remove everything, also delete `mod_loader/` and `mods/` from the user data folder.

## Troubleshooting

- **Mods stopped working after an update or "Verify integrity of game files":** Steam may have removed `override.cfg`. Copy it back into the game folder.
- **Mods don't load at all:** check that the launch options contain `%command% --enable-mods`. Without it the log shows `[ModLoader] mods disabled`.
- **Logs:** `logs/godot.log` in the user data folder. Mod loader messages start with `[ModLoader]`.

extends Node
## Minimal mod loader for Throttle Trace.
## Injected via override.cfg next to the game executable.
##
## Mods live in user://mods/, each one a folder user://mods/<name>/ containing mod.gd.
## mod.gd must `extends Node`; it is added as a child of this loader, so _ready() runs after all game autoloads.
##
## Mods are only loaded when the game is started with --enable-mods
## (Steam launch options: `%command% --enable-mods`).

const MODS_DIR := "user://mods"
const ENABLE_FLAG := "--enable-mods"


func _ready() -> void:
	# Godot passes unknown args through get_cmdline_args(); args after "--" land in get_cmdline_user_args()
	if not (ENABLE_FLAG in OS.get_cmdline_args() or ENABLE_FLAG in OS.get_cmdline_user_args()):
		print("[ModLoader] mods disabled, add ", ENABLE_FLAG, " to the launch options to enable them")
		return
	DirAccess.make_dir_recursive_absolute(MODS_DIR)
	for n in DirAccess.get_directories_at(MODS_DIR):
		var path := MODS_DIR.path_join(n).path_join("mod.gd")
		if not FileAccess.file_exists(path):
			continue
		var script = load(path)
		if script == null or not script.can_instantiate():
			push_error("[ModLoader] failed to load " + path)
			continue
		var mod = script.new()
		if not mod is Node:
			push_error("[ModLoader] " + path + " must extend Node")
			continue
		mod.name = n
		add_child(mod)
		print("[ModLoader] loaded mod ", mod.name)
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

var loaded_mods: Dictionary = {}


func _ready() -> void:
	# Godot passes unknown args through get_cmdline_args(); args after "--" land in get_cmdline_user_args()
	if not (ENABLE_FLAG in OS.get_cmdline_args() or ENABLE_FLAG in OS.get_cmdline_user_args()):
		print("[ModLoader] mods disabled, add ", ENABLE_FLAG, " to the launch options to enable them")
		return
	print("[ModLoader] starting, scanning ", ProjectSettings.globalize_path(MODS_DIR))
	DirAccess.make_dir_recursive_absolute(MODS_DIR)
	_load_mods()


func _load_mods() -> void:
	var names := DirAccess.get_directories_at(MODS_DIR)
	names.sort()
	for n in names:
		var base := MODS_DIR.path_join(n)
		var path := base.path_join("mod.gd")
		if not FileAccess.file_exists(path):
			continue
		var script = load(path)
		if script == null:
			push_error("[ModLoader] failed to load " + path)
			continue
		var mod: Node = script.new()
		mod.name = n
		loaded_mods[mod.name] = mod
		add_child(mod)
		print("[ModLoader] loaded mod ", mod.name)


## Replace a game script with a subclass of it. Call from a mod's _init() or _ready(),
## BEFORE the game instantiates the target (works for scenes loaded later, not for autoloads already running).
## child_script_path's script must `extends "res://path/to/original.gd"`.
func install_script_extension(child_script_path: String) -> void:
	var child: Script = load(child_script_path)
	var parent: Script = child.get_base_script()
	child.new()  # force compile/caching of the chain
	child.take_over_path(parent.resource_path)
	print("[ModLoader] extended ", parent.resource_path, " with ", child_script_path)

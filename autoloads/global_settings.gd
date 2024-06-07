extends SettingsCollection

const _PATH = "res://data/global_settings.GSON"

# Settings
var v_sync_setting = BoolSetting.new("V-Sync", "graphics", "Controls whether the game uses V-Sync.")
var window_mode_setting = MultiChoiceSetting.new("Window Mode", "window", "Controls the window mode.", "Windowed", ["Fullscreen", "Borderless Fullscren", "Windowed", "Borderless Windowed"])

var pause_key = InputEventKey.new()

func _init():
	add_setting(v_sync_setting)
	add_setting(window_mode_setting)
	
	pause_key.physical_keycode = InputMap.action_get_events("pause")[0].physical_keycode
	var pause_key_setting = KeySetting.new("Pause Key", "Input", "The key used to pause the game.", pause_key)
	add_setting(pause_key_setting)

	v_sync_setting.on_setting_changed.connect(on_v_sync_updated)
	window_mode_setting.on_setting_changed.connect(on_window_mode_updated)
	
	if FileAccess.file_exists(_PATH):
		load_from_GSON(_PATH)

func on_v_sync_updated():
	if v_sync_setting.get_value() == true:
		ProjectSettings["display/window/vsync/vsync_mode"] = DisplayServer.VSYNC_ENABLED
	else:
		ProjectSettings["display/window/vsync/vsync_mode"] = DisplayServer.VSYNC_DISABLED

func on_window_mode_updated():
	var mode:String = window_mode_setting.get_value()
	var window := get_window()
	if mode == "Fullscreen":
		window.borderless = false
		window.mode = Window.MODE_FULLSCREEN
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED
		window.always_on_top = true
	elif mode == "Borderless Fullscreen":
		window.borderless = true
		window.mode = Window.MODE_FULLSCREEN
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED
		window.always_on_top = true
	elif mode == "Windowed":
		window.borderless = false
		window.mode = Window.MODE_WINDOWED #Exclusive has no effect.
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		window.always_on_top = false
	elif mode == "Borderless Windowed":
		window.borderless = true
		window.mode = Window.MODE_WINDOWED
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		window.always_on_top = false



func _exit_tree():
	save_to_GSON(_PATH)
	

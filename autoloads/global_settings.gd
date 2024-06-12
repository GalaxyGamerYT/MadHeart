extends SettingsCollection

# Settings
var v_sync_setting = BoolSetting.new("V-Sync", "graphics", "Controls whether the game uses V-Sync.")
var window_mode_setting = MultiChoiceSetting.new("Window Mode", "window", "Controls the window mode.", "Windowed", ["Windowed", "Borderless Windowed", "Fullscreen", "Borderless Fullscreen"])

func _init():
	add_setting(v_sync_setting)
	add_setting(window_mode_setting)
	
	var keys:Dictionary = get_keys()

	# Input Settings
	for keyName in keys:
		#print(keys[keyName]["key"])
		var key_setting = KeySetting.new(keyName+" Key", "Input", "The key used to "+keys[keyName]["tooltip"], keys[keyName]["key"])
		add_setting(key_setting)

	v_sync_setting.on_setting_changed.connect(on_v_sync_updated)
	window_mode_setting.on_setting_changed.connect(on_window_mode_updated)
	
	if FileAccess.file_exists(GameController.global_settings_GSON):
		load_from_GSON(GameController.global_settings_GSON)

func get_keys()->Dictionary:
	var keysDict:Dictionary = {}
	var actionArr:Array = []
	
	for action in InputMap.get_actions():
		if !action.begins_with("ui_"):
			actionArr.append(action)
	
	for actionName in actionArr:
		var key = InputMap.action_get_events(actionName)[0]
		keysDict[actionName] = {}
		keysDict[actionName]["key"] = key
		var tooltip:String = actionName+"."
		
		match actionName:
			"left":
				tooltip = "move the player left."
			"up":
				tooltip = "move the player up."
			"right":
				tooltip = "move the player right."
			"down":
				tooltip = "move the player down."
			"zoom_in":
				tooltip = "zoom the camera in."
			"zoom_out":
				tooltip = "zoom the camera out."
			"show_seed":
				tooltip = "show the world seed."
			"pause":
				tooltip = "pause the game."
		
		keysDict[actionName]["tooltip"] = tooltip
	
	return keysDict

func on_v_sync_updated():
	if v_sync_setting.get_value() == true:
		ProjectSettings["display/window/vsync/vsync_mode"] = DisplayServer.VSYNC_ENABLED
	else:
		ProjectSettings["display/window/vsync/vsync_mode"] = DisplayServer.VSYNC_DISABLED

func on_window_mode_updated():
	print("HERE")
	var mode:String = window_mode_setting.get_value()
	var window := get_window()
	match mode:
		"Fullscreen":
			#window.borderless = false
			#window.mode = Window.MODE_FULLSCREEN
			#Input.mouse_mode = Input.MOUSE_MODE_CONFINED
			#window.always_on_top = true
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
			print("Fullscreen")
		"Borderless Fullscreen":
			#window.borderless = true
			#window.mode = Window.MODE_FULLSCREEN
			#Input.mouse_mode = Input.MOUSE_MODE_CONFINED
			#window.always_on_top = true
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
			print("Borderless Fullscreen")
		"Windowed":
			#window.borderless = false
			#window.mode = Window.MODE_WINDOWED #Exclusive has no effect.
			#Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			#window.always_on_top = false
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			print("Windowed")
		"Borderless Windowed":
			#window.borderless = true
			#window.mode = Window.MODE_WINDOWED
			#Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			#window.always_on_top = false
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
			print("Borderless Windowed")

func _exit_tree():
	save_to_GSON(GameController.global_settings_GSON)
	

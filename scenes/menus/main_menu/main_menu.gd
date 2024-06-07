extends Control

var world_creation_scene = preload("res://scenes/menus/world_creation_menu/world_creation_menu.tscn") as PackedScene

func on_start_pressed():
	print("Creating World")
	get_tree().change_scene_to_packed(world_creation_scene)

func on_exit_pressed():
	print("Quit")
	get_tree().quit()

func on_settings_pressed():
	print("Settings")
	var settings_dialog:ConfirmationDialog = GameController.settings_dialog_scene.instantiate()
	settings_dialog.title = "Options"
	add_child(settings_dialog)
	
	settings_dialog.get_node("SettingsPanel").settings_collection = GlobalSettings
	settings_dialog.popup_centered()

extends Control

var world_creation_scene = preload("res://scenes/menus/world_creation_menu/world_creation_menu.tscn") as PackedScene

func on_start_pressed():
	print("Play")
	get_tree().change_scene_to_packed(world_creation_scene)

func on_exit_pressed():
	print("Quit")
	get_tree().quit()

func on_settings_pressed():
	print("Settings")

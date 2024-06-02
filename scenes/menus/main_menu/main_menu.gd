extends Control

var level_select = "res://scenes/game/game.tscn"

func on_start_pressed():
	print("Level Select")
	LoadManager.load_scene(level_select)

func on_exit_pressed():
	print("Quit")
	get_tree().quit()

func on_settings_pressed():
	print("Settings")

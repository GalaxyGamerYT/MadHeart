extends Control

@onready var game

@onready var main_menu = preload("res://scenes/menus/main_menu/main_menu.tscn") as PackedScene

func _ready():
	game = get_tree().get_root().get_node("Game")
	hide()


func _on_game_toggle_game_paused(is_paused):
	if is_paused:
		show()
	else:
		hide()


func _on_resume_btn_pressed():
	game.game_paused = false

func save():
	pass

func _on_exit_btn_pressed():
	game.game_paused = false
	save()
	get_tree().change_scene_to_packed(main_menu)


func _on_save_btn_pressed():
	game.game_paused = false
	save()


func _on_options_btn_pressed():
	var settings_dialog:ConfirmationDialog = GameController.settings_dialog_scene.instantiate()
	settings_dialog.title = "Options"
	add_child(settings_dialog)
	
	settings_dialog.get_node("SettingsPanel").settings_collection = GlobalSettings
	settings_dialog.popup_centered()

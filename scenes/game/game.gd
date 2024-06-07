extends Node2D

@onready var camera_2d = $Player/Camera2D

var min_zoom: int = 0
@export var max_zoom: float = 2

signal toggle_game_paused(is_paused : bool)

var game_paused : bool = false:
	get:
		return game_paused
	set(value):
		game_paused = value
		get_tree().paused = game_paused
		emit_signal("toggle_game_paused", game_paused)

func _input(event :InputEvent):
	if Input.is_action_just_pressed("zoom_out"):
		var zoom_val = camera_2d.zoom.x - 0.1
		if zoom_val <= min_zoom:
			zoom_val = min_zoom
		camera_2d.zoom = Vector2(zoom_val,zoom_val)
	if Input.is_action_just_pressed("zoom_in"):
		var zoom_val = camera_2d.zoom.x + 0.1
		if zoom_val >= max_zoom:
			zoom_val = max_zoom
		camera_2d.zoom = Vector2(zoom_val,zoom_val)
	if Input.is_action_just_pressed("show_seed"):
		print("Seed: "+str(GameController.seed))
	
	if event.is_action_pressed("pause"):
		game_paused = !game_paused

func show_settings():
	#print("Settings function")
	#pass
	
	var settings_dialog:ConfirmationDialog = GameController.settings_dialog_scene.instantiate()
	settings_dialog.title = "Global settings"
	add_child(settings_dialog)
	
	settings_dialog.get_node("SettingsPanel").settings_collection = GlobalSettings
	settings_dialog.popup_centered()


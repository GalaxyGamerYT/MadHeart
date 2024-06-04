extends Node2D

@onready var camera_2d = $Player/Camera2D

var min_zoom: int = 0
@export var max_zoom: float = 2

func _input(event):
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

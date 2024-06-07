extends Control


@onready var world_name_entry = $MarginContainer/VBoxContainer/Setting/LineEdit as LineEdit
@onready var seed_entry = $MarginContainer/VBoxContainer/Setting2/LineEdit as LineEdit

var game_scene = "res://scenes/game/game.tscn"

var last_world_num: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_create_btn_pressed():
	var world_name_text: String = world_name_entry.text
	if world_name_text:
		GameController.world_name = world_name_text
	else:
		GameController.world_name = "World"+str(last_world_num+1)
	
	var seed_text: String = seed_entry.text
	var seed: String = ""
	if seed_text:
		seed = seed_text
	GameController.seed = seed
	
	print("Play")
	LoadManager.load_scene(game_scene)
	

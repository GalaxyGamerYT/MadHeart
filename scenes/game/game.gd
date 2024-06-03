extends Node2D

@onready var camera_2d = $Player/Camera2D

@export var noise_height_texture : NoiseTexture2D
@export var noise_tree_texture: NoiseTexture2D
var height_noise : Noise
var tree_noise : Noise

@export var width : int = 400
@export var height : int = 400

@onready var tile_map = $TileMap as TileMap

var source_id = 0

var water_layer = 0
var ground_1_layer = 1
var ground_2_layer = 2
var cliff_layer = 3
var environment_layer = 4

var water_atlas = Vector2i(0,1)
var land_atlas = Vector2i(0,0)

var sand_tiles_arr = []
var terrain_sand_int = 0

var grass_tiles_arr = []
var terrain_grass_int = 1

var cliff_tiles_arr = []
var terrain_cliff_int = 3

var grass_atlas_arr = [Vector2i(1,0),Vector2i(2,0),Vector2i(3,0),Vector2i(4,0),Vector2i(5,0)]
var palm_tree_atlas_arr = [Vector2i(12,2), Vector2i(15,2)]
var oak_tree_atlas = Vector2i(15,6)

@export var seedName := GameController.seed
var set_seed : int

func _ready():
	randomize()	
	if seedName:
		set_seed = hash(seedName)
	else:
		set_seed = randi()
	height_noise = noise_height_texture.noise
	tree_noise = noise_tree_texture.noise
	
	height_noise.seed = set_seed
	tree_noise.seed = set_seed
	generate_world()

func generate_world():
	for x in range(-width/2, width/2):
		for y in range(-height/2, height/2):
			var height_noise_val = height_noise.get_noise_2d(x,y)
			var tree_noise_val = tree_noise.get_noise_2d(x,y)
			
			# placeing ground
			if height_noise_val >= 0.0:
				
				if height_noise_val > 0.05 and height_noise_val < 0.17 and tree_noise_val > 0.8:
					# Palm trees on sand
					tile_map.set_cell(environment_layer, Vector2i(x,y), source_id, palm_tree_atlas_arr.pick_random())
				
				if height_noise_val > 0.2:
					# Grass on sand
					grass_tiles_arr.append(Vector2i(x,y))
					
					if height_noise_val > 0.25:
						
						if height_noise_val < 0.35 and tree_noise_val > 0.8:
							# Oak Tree on grass
							tile_map.set_cell(environment_layer, Vector2i(x,y), source_id, oak_tree_atlas)
							
						# grass/flowers on top of grass tiles.
						tile_map.set_cell(ground_2_layer, Vector2i(x,y), source_id, grass_atlas_arr.pick_random())
						
					if height_noise_val > 0.5:
						# Cliffs on grass
						cliff_tiles_arr.append(Vector2i(x,y))
				
				# Sand on water
				sand_tiles_arr.append(Vector2i(x,y))
				
			# Water on every tile.
			tile_map.set_cell(water_layer, Vector2i(x,y), source_id, water_atlas)
	
	tile_map.set_cells_terrain_connect(ground_1_layer, sand_tiles_arr, terrain_sand_int, 0)
	tile_map.set_cells_terrain_connect(ground_1_layer, grass_tiles_arr, terrain_grass_int, 0)
	tile_map.set_cells_terrain_connect(cliff_layer, cliff_tiles_arr, terrain_cliff_int, 0)

func _input(event):
	if Input.is_action_just_pressed("zoom_in"):
		var zoom_val = camera_2d.zoom.x - 0.1
		if zoom_val <= 0:
			zoom_val = 0
		camera_2d.zoom = Vector2(zoom_val,zoom_val)
	if Input.is_action_just_pressed("zoom_out"):
		var zoom_val = camera_2d.zoom.x + 0.1
		if zoom_val >= 5:
			zoom_val = 5
		camera_2d.zoom = Vector2(zoom_val,zoom_val)

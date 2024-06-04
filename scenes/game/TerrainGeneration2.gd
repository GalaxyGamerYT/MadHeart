extends TileMap

var moisture = FastNoiseLite.new() #X Offset
var temperature = FastNoiseLite.new()# Y Offset
var altitude = FastNoiseLite.new()# Oceans

@export var width: int = 64
@export var height: int = 64
@export var seedName :String = GameController.seed

@onready var player = get_tree().current_scene.get_node("Player")

var loaded_chunks = []
var set_seed: int

var scource_id: int = 0

func _ready():
	randomize()	
	if seedName:
		if seedName.is_valid_int():
			set_seed = int(seedName)
		else:
			set_seed = hash(seedName)
	else:
		set_seed = randi()
	
	moisture.seed = set_seed
	temperature.seed = set_seed
	altitude.seed = set_seed
	GameController.seed = str(set_seed)
	
	altitude.frequency = 0.01

func _process(delta):
	var player_tile_pos = local_to_map(player.position)
	
	generate_chunk(player_tile_pos)
	
	unload_distant_chunks(player_tile_pos)

func generate_chunk(pos):
	for x in range(width):
		for y in range(height):
			
			var moist = moisture.get_noise_2d(pos.x - (width/2) + x, pos.y - (height/2) + y) * 10
			var temp = temperature.get_noise_2d(pos.x - (width/2) + x, pos.y - (height/2) + y) * 10
			var alt = altitude.get_noise_2d(pos.x - (width/2) + x, pos.y - (height/2) + y) * 10
			
			if alt < 0:
				set_cell(0, Vector2i(pos.x - (width/2) + x, pos.y - (height/2) + y), scource_id, Vector2i(3, round(3 * (temp + 10) / 20)))
				
			else:
				set_cell(0, Vector2i(pos.x - (width/2) + x, pos.y - (height/2) + y), scource_id, Vector2i(round(3 * (moist + 10) / 20), round(3 * (temp + 10) / 20)))
			
			if Vector2i(pos.x, pos.y) not in loaded_chunks:
				loaded_chunks.append(Vector2i(pos.x, pos.y))

func clear_chunk(pos):
	for x in range(width):
		for y in range(height):
			#set_cell(0, Vector2i(pos.x - (width/2) + x, pos.y - (height/2) + y), -1, Vector2i(-1,-1))
			erase_cell(0, Vector2i(pos.x - (width/2) + x, pos.y - (height/2) + y))

func unload_distant_chunks(player_pos):
	var unload_dist = (width * 2) + 1
	
	for chunk in loaded_chunks:
		var dist_to_player = dist(chunk, player_pos)
		
		if dist_to_player > unload_dist:
			clear_chunk(chunk)
			loaded_chunks.erase(chunk)

func dist(p1, p2):
	var r = p1-p2
	return sqrt(r.x ** 2 + r.y ** 2)

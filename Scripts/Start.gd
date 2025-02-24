extends Node3D

var grassBlock = load("res://Blocks/GrassBlock.tscn")
var dirtBlock = load("res://Blocks/DirtBlock.tscn")
var cobbleBlock = load("res://Blocks/CobblestoneBlock.tscn")
var glassBlock = load("res://Blocks/Glass.tscn")

var origin_height: int
var noise = FastNoiseLite.new()
var width = 16
var depth = 16
var generated_chunks = []


func _ready():
	origin_height = floor(depth * noise.get_noise_2d(1, 1))
	$Player.position = Vector3(1, origin_height+2, 1)

	generate_surrounding_chunks($Player.position)


func generate_chunk(base_position):
	var chunk_x_start = (int(floor(base_position.x)) / 16) * 16
	var chunk_z_start = (int(floor(base_position.z)) / 16) * 16

	var chunk_id = Vector2(chunk_x_start, chunk_z_start)
	if chunk_id in generated_chunks:
		return

	generated_chunks.append(chunk_id)

	for i in range(chunk_x_start, chunk_x_start+16):
		for j in range(chunk_z_start, chunk_z_start+16):
			var raw_noise = noise.get_noise_2d(i, j)
			var terrain_height = floor(depth * raw_noise)

			for k in range(-depth, terrain_height):
				var cur_block = grassBlock
				if k < terrain_height - 1:
					cur_block = dirtBlock
				if k < -16:
					cur_block = cobbleBlock

				var instance = cur_block.instantiate()
				add_child(instance)
				instance.global_transform.origin = Vector3(i, k, j)


# TODO: Rather poll the player position from game script than have 
# player controller know about chunks
func _on_player_moved_chunk(cur_pos_v3d):
	generate_surrounding_chunks(cur_pos_v3d)


# TODO: Multithreading this doesn't work because add_child runs on main thread
# The right way to fix chunk generation lag is to keep all blocks loaded and
# scroll them as the player moves to new chunks, hiding old chunks behind the player
func generate_surrounding_chunks(base_position, x_chunks=2, z_chunks=2):
	var chunk_x = (int(floor(base_position.x)) / 16)
	var chunk_z = (int(floor(base_position.z)) / 16)

	var chunks_to_gen = []
	for x in range(chunk_x - x_chunks, chunk_x + x_chunks):
		for z in range(chunk_z - z_chunks, chunk_z + z_chunks):
			generate_chunk(Vector3(x*16, 0, z*16))

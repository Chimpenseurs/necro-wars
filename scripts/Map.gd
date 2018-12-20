extends Node2D

const Level = preload("res://scripts/LevelApi.gd")
var metalayer

# Information zones
onready var zones = get_node("Zones")

func _ready():
	self.metalayer = $LayerMeta
	$LayerMeta.set_script(preload("res://scripts/LayerMeta.gd"))
	# When using `set_script`, the _ready method is not called
	# so we call a function fill_up that will init the scripts variables 
	$LayerMeta.fill_up()
	
func get_cellv(pos):
	var cell_type = metalayer.get_cell_type(pos)
	if cell_type != null:
		return Level.Cell.new(pos, cell_type, metalayer.map_to_world(pos))
	return null

func is_valid_cellv(pos):
	return metalayer.get_cellv(pos) != metalayer.INVALID_CELL

func get_neighbors(pos):
	var neighbor_poses = [ 
		pos+Vector2(1, 0), 
		pos+Vector2(0, 1), 
		pos+Vector2(-1, 0), 
		pos+Vector2(0, -1) 
	]

	var neighbors = []
	for n in neighbor_poses:
		var layer_cell = self.get_cellv(n)
		if layer_cell != null:
			neighbors.append(layer_cell)

	return neighbors
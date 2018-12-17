extends Node2D

const Level = preload("res://scripts/LevelApi.gd")


onready var layer0 = get_node("Layer0")
onready var layer1 = get_node("Layer1")
onready var metalayer = get_node("LayerMeta")

# Information zones
onready var zones = get_node("Zones")

func _ready():
	pass
	
func get_cellv(pos):
	var cell_type = metalayer.get_cell_type(pos)
	if cell_type != null:
		return Level.Cell.new(pos, cell_type, metalayer.map_to_world(pos))
	return null

func is_valid_cellv(pos):
	return layer0.get_cellv(pos) != layer0.INVALID_CELL

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
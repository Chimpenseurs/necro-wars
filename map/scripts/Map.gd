extends Node2D

const Dcell = preload("res://common/scripts/Dijkstra.gd")

onready var layer0 = get_node("Layer0")
onready var layer1 = get_node("Layer1")

# Information zones
onready var zones = get_node("Zones")

func _ready():
	pass
	
func get_cellv(pos):
	var layer_cell = layer0.get_cellv(pos)
	if layer_cell != layer0.INVALID_CELL:
		if layer_cell == 468:
			return Dcell.Cell.new(pos, 2)
		else:
			return Dcell.Cell.new(pos, 1)
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
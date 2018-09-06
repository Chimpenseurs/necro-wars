extends Node2D

var units = []
var level_configuration = { "tile_size" : 32 }

func _ready():
	var godot = self.get_node("Godot")
	var map = self.get_node("Map")
	
	var cursor = self.get_node("Cursor")
	cursor.set_map(map)
	cursor.set_units(units)
	
	units.append(godot)

func get_configuration():
	return level_configuration
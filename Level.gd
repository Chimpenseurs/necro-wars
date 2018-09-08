extends Node2D

const Dcell = preload("./common/scripts/Dijkstra.gd")

var units = []
var level_configuration = { "tile_size" : 32 }

# Information zones
onready var map = get_node("Map")
onready var zones = get_node("Zones") 
onready var godot = get_node("Godot")
onready var cursor = get_node("Cursor")

func _ready():
		# Gently reminder
	
	cursor.set_map(self)
	cursor.set_units(units)

	units.append(godot)

func get_configuration():
	return level_configuration

func display_zone(zone):
	for k in zone.keys():
		zones.set_cellv(k, 0)

func clear_zones():
	zones.clear()
	
# The pos is in map unit
func dijkstra(pos, distance_max):
	var cell = map.get_cellv(pos)
	if cell == null:
		#Initial cell does not exist
		return null

	var initial = Dcell.Dcell.new(cell, 0)
	var stack = [ initial ]
	var memory = { }
	
	memory[ initial.cell.pos ] = initial

	while stack.size() > 0:

		var current = find_min_in_array(stack)
		var neighbors = map.get_neighbors(current.cell.pos)

		for neighbor in neighbors:
			var dcell = Dcell.Dcell.new(neighbor, -1)
	
			var alt = current.distance + current.cell.speed

			if alt  <= distance_max:
				if !memory.has(dcell.cell.pos):
					memory[dcell.cell.pos] = dcell

				if memory[dcell.cell.pos].distance == -1 or alt < memory[dcell.cell.pos].distance:
					dcell.distance = alt
					stack.append(dcell)

	return memory

func find_min_in_array(array):
	var min_ = null
	if array.size() == 0:
		return null

	for i in range(array.size()):
		if min_ == null:
			min_ = 0
		if array[i].distance < min_:
			min_ = i
	var cell = array[min_]
	array.remove(min_)
	return cell

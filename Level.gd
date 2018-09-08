extends Node2D

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
	
class Dcell:
	var pos
	var distance

	func _init(p, d):
		self.pos = p
		self.distance = d

# The pos is in map unit
func dijkstra(pos, distance):
	var cell = map.get_cellv(pos)
	if cell == map.INVALID_CELL:
		#Initial cell does not exist
		return null

	var stack = [ Dcell.new(pos, 0) ]
	var memory = { }
	memory[stack[0].pos] = stack[0]

	while stack.size() > 0:
		print(stack.size())
		var current = find_min_in_array(stack)
		var neighbors = [
			Dcell.new(current.pos+Vector2(1, 0), -1),
			Dcell.new(current.pos+Vector2(0, 1), -1), 
			Dcell.new(current.pos+Vector2(-1, 0), -1), 
			Dcell.new(current.pos+Vector2(0, -1), -1) 
		]
		for neighbor in neighbors:
			if map.get_cellv(neighbor.pos) != map.INVALID_CELL:
				if !memory.has(neighbor.pos):
					memory[neighbor.pos] = neighbor
				if memory[neighbor.pos].distance == -1 or current.distance + 1 < memory[neighbor.pos].distance :
					neighbor.distance = current.distance + 1
					if neighbor.distance < distance:
						stack.append(neighbor)
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
extends Node2D

const LevelApi = preload("./common/scripts/LevelApi.gd")

var units = []
var level_configuration = { "tile_size" : 32 }

# Information zones
onready var map = get_node("Map")
onready var zones = get_node("Zones") 
onready var godot = get_node("Godot")
onready var cursor = get_node("Cursor")

func _ready():
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
	# Get the initial cell from the map
	var cell = map.get_cellv(pos) 
	if cell == null:
		#Initial cell does not exist
		return null

	var initial = LevelApi.Dcell.new(cell, 0)
	var stack = [ initial ]
	# The memory is the result of the disjkstra algortihm
	# It will contains all accessible nodes
	var memory = { }
	memory[ initial.cell.pos ] = initial
	
	while stack.size() > 0:
		# We find the minimun in the stack
		# Can be a point to optimize later
		var current = find_min_in_array(stack)

		# We ask the map to find all neighbors of the current pos
		var neighbors = map.get_neighbors(current.cell.pos)
		var distance = LevelApi.cell_distance(current.cell, "Ground") 

		for neighbor in neighbors:
			# We get the distance from the current
			var distance_neighbor = LevelApi.cell_distance(neighbor, "Ground") 

			if distance != LevelApi.BLOCK  and distance_neighbor != LevelApi.BLOCK:
				var dcell = LevelApi.Dcell.new(neighbor, LevelApi.INFINITY)

				var alt = current.distance + distance
				if alt  <= distance_max:
					if !memory.has(dcell.cell.pos):
						memory[dcell.cell.pos] = dcell

					if memory[dcell.cell.pos].distance == LevelApi.INFINITY or alt < memory[dcell.cell.pos].distance:
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

extends Node2D

const LevelApi = preload("./common/scripts/LevelApi.gd")
const cursor_tscn = preload("res://cursor/scenes/Cursor.tscn")

var level_configuration = { "tile_size" : 32 }

# The world map
onready var map = get_node("Map")
# Information zones
onready var zones = get_node("Zones") 
# List of units on map
onready var units = get_node("Units").get_children()

onready var cursor = cursor_tscn.instance()

func _ready():
	cursor.set_level(self)
	cursor.set_units(units)
	cursor.set_map(self.map)
	
	self.add_child(cursor)

func display_zone(zone):
	for k in zone.keys():
		zones.set_cellv(k, 0)

func get_configuration():
	return level_configuration

func get_map():
	return self.map

func clear_zones():
	zones.clear()
	
# pos: The initial position on the map to compute dijkstra from
# distance_max: The size of the zone we want to explore
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

		# We get the distance to leave the cell
		# TODO So if you stop on a map, you get double bonus/malus?
		var distance = LevelApi.cell_distance(current.cell, "Ground") 

		for neighbor in neighbors:
			# We get the distance from the current
			var distance_neighbor = LevelApi.cell_distance(neighbor, "Ground") 
			
			# We need to check is we can enter/leave the cell
			if distance != LevelApi.BLOCK  and distance_neighbor != LevelApi.BLOCK:
				var dcell = LevelApi.Dcell.new(neighbor, LevelApi.INFINITY)
				var alt = current.distance + distance

				# This one checks if we reached the max distance
				if alt  <= distance_max:
					if !memory.has(dcell.cell.pos):
						memory[dcell.cell.pos] = dcell
					# Finally the last check of dijkstra (see original algorithm)
					if memory[dcell.cell.pos].distance == LevelApi.INFINITY or alt < memory[dcell.cell.pos].distance:
						# We update the distance
						dcell.distance = alt
						# Save where we came from
						dcell.from = current
						# Add the neighbor to the stack
						stack.append(dcell)

	return memory

# As Gdscript does not provide priorityqueu,
# this function extract the min from an array
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
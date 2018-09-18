tool
extends Node2D

const LevelApi     = preload("./common/scripts/LevelApi.gd")
const cursor_tscn  = preload("res://cursor/scenes/Cursor.tscn")

var level_configuration = { "tile_size" : 32 }

# The world map
onready var map = get_node("Map")
# Information zones
onready var zones = get_node("Zones") 
# List of units on map
onready var units = get_node("Units").get_children()

onready var player1 = cursor_tscn.instance()
onready var player2 = cursor_tscn.instance()

var player_stack = [ ]

func init_human_player(player, id, color):
	var camera = Camera2D.new()
	set_camera_limits(camera)
	camera.set_name(id)
	player.player_id = id
	# Init cursor
	player.set_camera(camera)

	player.set_level(self)
	player.set_units(units)
	player.set_map(self.map)

	player.set_color(color)
	return player
	
func _ready():
	var c = Color(0.2, 1.0, .7, .8) # a color of an RGBA(51, 255, 178, 204)
	
	player_stack.append(self.init_human_player(player2, "player1", c))
	self.add_child(player2)
	
	player_stack.append(self.init_human_player(player1, "player2", c.inverted()))
	self.add_child(player1)
	
	self.init_level_player()

func set_camera_limits(camera):
	var map_limits = $Map/LayerMeta.get_used_rect()
	var map_cellsize = $Map/LayerMeta.cell_size
	
	camera.limit_left = (map_limits.position.x * map_cellsize.x) - 1
	camera.limit_right = map_limits.end.x * map_cellsize.x
	camera.limit_top = map_limits.position.y * map_cellsize.y
	camera.limit_bottom = map_limits.end.y * map_cellsize.y
	
	camera.zoom = Vector2(0.75, 0.75)


func init_level_player():
	for player in player_stack:
		player.set_inactive()

	var next_player = player_stack.pop_front()
	next_player.set_active()

func end_turn(player):
	player.set_inactive()
	player_stack.append(player)
	var next_player = player_stack.pop_front()
	next_player.set_active()
	
func display_circle(circle):
	for pos in circle:
		zones.set_cellv(pos, 1) # default move zone sprite

func display_zone(zone):
	for k in zone.keys():
		get_circle(zone[k].cell.pos , 1)

	for k in zone.keys(): # k is a pos
		zones.set_cellv(k, 0) # default move zone sprite
		if zone[k].ennemy :
			zones.set_cellv(k, 1) # attack zone sprite

func get_configuration():
	return level_configuration

func get_map():
	return self.map

func clear_zones():
	zones.clear()

func get_attack_range(movement_zone, radis):
	var attack_range = []
	for k in movement_zone.keys():
		attack_range += get_circle(movement_zone[k].cell.pos , radis)
	return attack_range

# get the circle around the character
func get_circle(pos, radius):
	
	var circle = []
	var x =  0
	var y = radius
	
	while x <= y :
		
		for v in [
			Vector2(x, y), Vector2(y, x), 
			Vector2(-x, y), Vector2(-y, x), 
			Vector2(x, -y), Vector2(y, -x), 
			Vector2(-x, -y), Vector2(-y, -x)
			]:
			
			if not circle.has(v) :
				circle.append(v+pos)
		
		y = y - 1
		x = x + 1

	return circle

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
		if current.distance < distance_max:
			# We ask the map to find all neighbors of the current pos
			var neighbors = map.get_neighbors(current.cell.pos)

			# We get the distance to leave the cell
			# TODO So if you stop on a map, you get double bonus/malus?
			var distance = LevelApi.cell_distance(current.cell, "Ground") 
			var alt = current.distance + distance

			for neighbor in neighbors:
				if !memory.has(neighbor.pos):
					memory[neighbor.pos] = LevelApi.Dcell.new(neighbor, LevelApi.INFINITY)

				var dcell = memory[neighbor.pos]

				if dcell.accessible:
					for u in units :
					# TODO : parse allies
						if u.pos != pos and u.pos == dcell.cell.pos:
							dcell.ennemy = true
							dcell.accessible = false 

				if dcell.accessible:
					# We get the distance from the current
					var distance_neighbor = LevelApi.cell_distance(neighbor, "Ground") 
					# We need to check is we can enter/leave the cell
					if distance_neighbor != LevelApi.BLOCK:
						# This one checks if we reached the max distance
						# Finally the last check of dijkstra (see original algorithm)
						if memory[dcell.cell.pos].distance == LevelApi.INFINITY or alt < memory[dcell.cell.pos].distance:
							# We update the distance
							dcell.distance = alt
							# Save where we came from
							dcell.from = current
							# Add the neighbor to the stack
							stack.append(dcell)
					else:
						memory[dcell.cell.pos].accessible = false

	return LevelApi.refine_dijkstra_zone(memory, distance_max)

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
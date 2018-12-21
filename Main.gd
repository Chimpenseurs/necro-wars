tool
extends Node2D

const LevelApi     = preload("scripts/LevelApi.gd")
const cursor_tscn  = preload("res://scenes/Cursor.tscn")
const Level        = preload("res://scenes/level.tscn")
const zonesTs      = preload("res://assets/tilesezones.tres")

const TiledMapReader = preload("res://scripts/tiledmap_reader_adapter.gd")

var level_configuration = { "tile_size" : 32, "zone_opacity": 0.7 }

# Information zones
var zones

# List of units on map
onready var units = get_node("Units").get_children()

onready var tiled_map_reader = TiledMapReader.new()
onready var player1 = cursor_tscn.instance()
onready var player2 = cursor_tscn.instance()

var map
var player_stack = [ ]

func load_tmx_level(source):
	map = tiled_map_reader.build_scene("res://scenes/level2.tmx")
	# Load the script containing the function needed by the map
	var level_script = preload("res://scripts/Map.gd")
	map.set_script(level_script)
	map.set_name("Level")

	return map

func init_nodes():
	self.zones = TileMap.new()
	self.zones.set_name("Zones")
	self.zones.cell_size = Vector2(level_configuration["tile_size"], level_configuration["tile_size"])
	
	self.zones.tile_set = zonesTs
	self.zones.modulate = Color(1, 1, 1, level_configuration["zone_opacity"])
	
	self.map = self.load_tmx_level("res://scenes/level2.tmx")
	# map.z_index = -1 # 
	
	self.add_child(map)
	self.add_child(self.zones)
	
	# TODO: Find a way to di it preperly
	$Units.set_as_toplevel(true)
	self.map.get_node("LayerSky").set_as_toplevel(true)
	self.zones.set_as_toplevel(true)

func _ready():
	self.init_nodes()
	
	var c = Color(0.2, 1.0, .7, .8) # a color of an RGBA(51, 255, 178, 204)
	
	player_stack.append(self.init_human_player(player2, "player1", c))
	self.add_child(player2)
	
	player_stack.append(self.init_human_player(player1, "player2", c.inverted()))
	self.add_child(player1)
	
	self.init_level_player()

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

func set_camera_limits(camera):
	var map_limits = $Level/LayerMeta.get_used_rect()
	var map_cellsize = $Level/LayerMeta.cell_size
	
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
	next_player.player_init_turn()
	next_player.set_active()
	
func display_zone(zone, type = "DEFAULT"):
	var tile = 0

	if type == "ACCESSIBLE":
		tile = 1
	elif type == "DIRECT":
		tile = 2
	else:
		tile = 0

	for pos in zone:
		zones.set_cellv(pos, tile) # default move zone sprite

func display_dijkstra_zone(zone):
	for k in zone.keys(): # k is a pos
		zones.set_cellv(k, 0) # default move zone sprite


func get_configuration():
	return level_configuration

func get_map():
	return self.map

func clear_zones():
	zones.clear()

func get_attack_range(pos, radis):
	return get_circle_filled(pos, radis)

func get_attack_range_include_movement_range(movement_zone, radis):
	var attack_range = []
	for k in movement_zone.keys():
		attack_range += get_circle_filled(movement_zone[k].cell.pos , radis)
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
			
			if not circle.has(v+pos) :
				circle.append(v+pos)
		
		y = y - 1
		x = x + 1

	return circle

# get the circle around the character
func get_circle_filled(pos, radius):
	var results = []
	for i in range(1, radius):
		results = results + get_circle(pos, i)
	return results

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
	# At the end, we need to select only available nodes
	# beacause in order to work, dijkstra needs to loop through more
	# cells than the final results
	for k in memory.keys():
		if not memory[k].accessible or distance_max < memory[k].distance :
			memory.erase(k)
	return memory

func get_path_from_dijkstra(memory, target_pos):
	var target_cell = null
	var path = []
	for key in memory.keys():
		if memory[key].cell.pos == target_pos:
			target_cell = memory[key]

	var backtrack = target_cell
	while backtrack != null:
		path.append(backtrack.cell)
		backtrack = backtrack.from
	return path

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
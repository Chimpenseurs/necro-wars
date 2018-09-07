extends Node2D

var dimensions = Vector2()

onready var layer0 = get_node("Layer0")
onready var layer1 = get_node("Layer1")
var scene = load("res://units/scenes/Godot.tscn")
var godot = scene.instance()

func _ready():
	self.add_child(godot)
	godot.move(Vector2(5,5))
	
	# Gently reminder
	print(layer0.map_to_world(Vector2(1, 0)))
	print(layer0.world_to_map(Vector2(32, 0)))
	
	var test = dijkstra(Vector2(5, 5), null)
	for k in test.keys():
		layer1.set_cellv(k, test[k].distance)
		

# The pos is in map unit
func dijkstra(pos, distance):
	var cell = layer0.get_cellv(pos)
	if cell == layer0.INVALID_CELL:
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
			if !memory.has(neighbor.pos):
				memory[neighbor.pos] = neighbor
			
			if layer0.get_cellv(neighbor.pos) != layer0.INVALID_CELL:
				if memory[neighbor.pos].distance == -1 or current.distance + 1 < memory[neighbor.pos].distance:
					neighbor.distance = current.distance + 1
					stack.append(neighbor)
	return memory

class Dcell:
	var pos
	var distance
	
	func _init(p, d):
		self.pos = p
		self.distance = d
	
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
	
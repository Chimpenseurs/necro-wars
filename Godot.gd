extends Node2D

var pos = Vector2(2, 0)

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	self.position = pos * 32

func get_pos():
	return pos

func move(pos):
	self.pos = pos
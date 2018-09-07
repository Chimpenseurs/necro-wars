extends Node2D

var pos = Vector2(2, 0)
var distance = 3

func _ready():
	pass

func _process(delta):
	self.position = pos * 32

func get_pos():
	return pos

func move(pos):
	self.pos = pos

func get_movement_zone():
	
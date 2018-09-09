extends Node2D

var pos = Vector2(4, 2)
var speed = 3

func _ready():
	pass

func _process(delta):
	self.position = pos * 32

func get_pos():
	return pos

func move(pos):
	self.pos = pos
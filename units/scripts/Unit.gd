extends Node2D

var pos = Vector2(0, 0)
var speed = 3

func _ready():
	pos = self.position / 32

func get_pos():
	return pos

func move(pos):
	self.pos = pos
	self.position = pos * 32

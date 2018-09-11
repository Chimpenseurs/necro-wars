extends Node2D

var pos = Vector2(0, 0)
var speed = 10.0  # TODO : separate speed and move range
var attack_range = 1

func _ready():
	self.pos = self.position /32

func get_pos():
	return pos

func move(pos):
	self.pos = pos
	self.position = pos * 32

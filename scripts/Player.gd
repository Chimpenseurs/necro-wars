extends "res://scripts/Character.gd"


func init(var name, var sprite_texture_path) :
	.init(name, sprite_texture_path)

func _ready():
	self.add_to_group("players")

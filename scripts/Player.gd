extends "res://scripts/Character.gd"


func init(var name, var sprite_texture_path) :
	self.c_name = name
	self.sprite_texture_path = sprite_texture_path

func _ready():
	self.add_to_group("players")

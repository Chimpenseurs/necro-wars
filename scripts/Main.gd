extends Node

func _ready():
	
	# Connect map with hud
	var hud_charac = get_node("hud_character")
	var map = get_node("map")
	map.connect("on_character", hud_charac, "set_character")
	
	# Connect map with self
	map.connect("at_player", self, "at_player")

func at_player(var player) :
	get_node("player").text = "At player : " + player.c_name
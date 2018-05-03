extends Control

func _ready():
	pass

func set_character(var character) :
	
	var h_sprite = get_node("sprite")
	
	if character != null :
		
		#Load texture
		var c_sprite = character.get_node("sprite")
		h_sprite.texture = load(c_sprite.texture.resource_path)
		
		# TODO : Load c_name and characteristics
		
	elif h_sprite.texture != null :
		
		h_sprite.texture = null

extends Control

func _ready():
	pass

func set_character(var character) :
	
	var h_sprite = get_node("sprite")
	var h_characs = get_node("characteristics")
	
	if h_sprite.texture != null :
		h_sprite.texture = null
	
	# init default
	for child in h_characs.get_children() :
		child.queue_free()
	
	if character != null :
		
		#Load texture
		var c_sprite = character.get_node("sprite")
		h_sprite.texture = load(c_sprite.texture.resource_path)
		
		#Load characteristics
		var c_characs = character.characteristics
		for key in c_characs.keys() :
			# Load characteristic name
			var charac_name = Label.new()
			charac_name.text = key
			
			# Load characteristic value
			var charac_value = Label.new()
			charac_value.text = String(c_characs[key])
			
			# Add characteristic
			var charac = HBoxContainer.new()
			charac.add_child(charac_name)
			charac.add_child(charac_value)
			
			h_characs.add_child(charac)
		

extends Node2D

var speed = 3

var move

func _init(var name = "godot"):
	self.name = name
	
	self.move = speed
	
	add_to_group("characters")

func _ready():
	
	gen_move_zone()

func gen_move_zone() :
	
	for i in range(self.move) :
		var cells = get_circle(i + 1)
		
		for cell in cells :
			
			var sprite = Sprite.new()
			sprite.centered = false
			sprite.texture = load("res://assets/img/move.png")
			sprite.position = cell*32
			
			
			get_node("move_zone").add_child(sprite)

# get the circle around the character
func get_circle(var radius) :
	
	var circle = []
	var x = 0
	var y = radius
	
	while x <= y :
		
		for v in [Vector2(x, y), Vector2(y, x), Vector2(-x, y), Vector2(-y, x), Vector2(x, -y), Vector2(y, -x), Vector2(-x, -y), Vector2(-y, -x)] :
			if not circle.has(v) :
				circle.append(v)
		
		y = y - 1
		x = x + 1
	
	return circle
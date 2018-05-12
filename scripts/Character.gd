extends Node2D

var c_name = ""

var life_max = 20
var life_current = life_max

var characteristics = {
	"speed": 3,
	"strengh": 5,
	"range": 1
}

var move
var move_zone_texture = "res://assets/img/move.png"

var sprite_texture_path = ""

func init(var name, var sprite_texture_path):
	self.c_name = name
	
	self.sprite_texture_path = sprite_texture_path
	

func _ready():
	
	self.move = self.characteristics["speed"]
	
	add_to_group("characters")
	
	# Load sprite texture
	self.get_node("sprite").texture = load(sprite_texture_path)
	
	gen_move_zone()
	get_node("move_zone").visible = false;
	
	gen_attack_zone()
	get_node("attack_zone").visible = false;


func move_to(var position) :
	
	self.position = position
	
	
	gen_move_zone()
	get_node("move_zone").visible = false;
	
	gen_attack_zone()
	get_node("attack_zone").visible = false;


func gen_attack_zone() :
	var attack_zone = get_node("attack_zone")
	
	for child in attack_zone.get_children() :
		child.queue_free()
	
	for i in range(self.characteristics["range"]) :
		var cells = get_circle(self.move + i + 1)
		
		for cell in cells :
			if get_parent().is_in_grid(self.position + cell*32) :
				
				var sprite = Sprite.new()
				sprite.centered = false
				sprite.texture = load("res://assets/img/attack.png")
				sprite.position = cell*32
				
				
				attack_zone.add_child(sprite)


func gen_move_zone() :
	
	var move_zone = get_node("move_zone")
	
	for child in move_zone.get_children() :
		child.queue_free()
	
	for i in range(self.move) :
		var cells = get_circle(i + 1)
		
		for cell in cells :
			if get_parent().is_in_grid(self.position + cell*32) :
				
				var sprite = Sprite.new()
				sprite.centered = false
				sprite.texture = load(move_zone_texture)
				sprite.position = cell*32
				
				
				move_zone.add_child(sprite)

func show_move_zone() :
	get_node("move_zone").visible = true
	get_node("attack_zone").visible = true

func hide_move_zone() :
	get_node("move_zone").visible = false
	get_node("attack_zone").visible = false

func is_in_move_zone(var position) :
	
	# update position based on character position
	position -= self.position
	
	for cell in get_node("move_zone").get_children() :
		if cell.position == position :
			return true
	
	return false

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
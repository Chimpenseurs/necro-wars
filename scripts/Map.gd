extends Node2D

const GRID_SIZE = 512 # in pixel
const CURSOR_SIZE = 32

var cursor_on_character = null
var character_selected = null

signal on_character

func _init():
	self.set_process_input(true)
	

func _ready():
	
	var p_scene = load("res://scenes/Player.tscn")
	
	var player01 = p_scene.instance()
	player01.init("Red Godot", "res://assets/img/red_godot.png")
	player01.position = Vector2(256, 256)
	
	
	var player02 = p_scene.instance()
	player02.init("Blue Godot", "res://icon.png")
	player02.position = Vector2(128, 128)
	
	
	self.add_child(player01)
	self.add_child(player02)
	
	
	# Load cursor
	var cursor = Sprite.new()
	cursor.name = "cursor"
	cursor.set_centered(false)
	cursor.texture = load("res://assets/img/cursor.png")
	self.add_child(cursor)

func _input(event):
	
	if event is InputEventKey : 
		
		if event.is_pressed() :
			
			var cursor_pos = get_node("cursor").position
			
			# CHARACTER MOTION
			if event.is_action("ui_select") :
				if character_selected == null :
					if cursor_on_character != null :
						character_selected = cursor_on_character
						character_selected.show_move_zone()
				elif cursor_on_character == null :
					# must be changed to a function
					character_selected.move_to(cursor_pos)
					character_selected.hide_move_zone()
					character_selected = null
			
			# CHARACTER DESELECTION
			if event.is_action("ui_cancel") :
				if character_selected != null :
					character_selected.hide_move_zone()
					character_selected = null
			
			
			
			# CURSOR MOTION
			if event.is_action("ui_right") or event.is_action("ui_left") or event.is_action("ui_up") or event.is_action("ui_down") :
				
				if event.is_action("ui_right") :
					cursor_pos.x += CURSOR_SIZE
				elif event.is_action("ui_left") :
					cursor_pos.x -= CURSOR_SIZE
				
				if event.is_action("ui_up") :
					cursor_pos.y -= CURSOR_SIZE
				elif event.is_action("ui_down") :
					cursor_pos.y += CURSOR_SIZE
			
			# check if cursor in on something after action
			if is_in_grid(cursor_pos) :
				
				# change cursor position
				if character_selected != null : 
					if character_selected.is_in_move_zone(cursor_pos) :
						get_node("cursor").position = cursor_pos
				else :
					get_node("cursor").position = cursor_pos
				
				# if cursor was on a character
				if cursor_on_character != null :
					if character_selected == null :
						cursor_on_character.hide_move_zone()
					cursor_on_character = null
				
				# if cursor is on a character
				for character in get_tree().get_nodes_in_group("characters") :
					if cursor_pos == character.position :
						cursor_on_character = character
						if character_selected == null :
							cursor_on_character.show_move_zone()
				
				if character_selected == null :
					emit_signal("on_character", cursor_on_character)


func _process(delta):
	pass


# To check if something is in the grid or not
func is_in_grid(var pos) :
	if pos.x >= 0 and pos.x < GRID_SIZE and pos.y >= 0 and pos.y < GRID_SIZE :
		return true
	
	return false

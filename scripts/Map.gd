extends Node2D

const GRID_SIZE = 512 # in pixel
const CURSOR_SIZE = 32

var cursor_on_character = null

func _init():
	self.set_process_input(true)
	

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _input(event):
	
	if event is InputEventKey : 
		
		if event.is_pressed() :
			
			if event.is_action("ui_right") or event.is_action("ui_left") or event.is_action("ui_up") or event.is_action("ui_down") :
				
				# CURSOR MOTION
				var cursor_pos = get_node("cursor").position
				if event.is_action("ui_right") :
					cursor_pos.x += CURSOR_SIZE
				elif event.is_action("ui_left") :
					cursor_pos.x -= CURSOR_SIZE
				
				if event.is_action("ui_up") :
					cursor_pos.y -= CURSOR_SIZE
				elif event.is_action("ui_down") :
					cursor_pos.y += CURSOR_SIZE
				
				# if movement is valid
				if is_in_grid(cursor_pos) :
					# change cursor position
					get_node("cursor").position = cursor_pos
					
					# if cursor was on a character
					if cursor_on_character != null :
						cursor_on_character.hide_move_zone()
						cursor_on_character = null
					
					# if cursor is on a character
					if cursor_pos == get_node("character").position :
						cursor_on_character = get_node("character")
						cursor_on_character.show_move_zone()


func _process(delta):
	pass


# To check if something is in the grid or not
func is_in_grid(var pos) :
	if pos.x >= 0 and pos.x < GRID_SIZE and pos.y >= 0 and pos.y < GRID_SIZE :
		return true
	
	return false

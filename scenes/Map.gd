extends Node2D

const GRID_SIZE = 512 # in pixel
const CURSOR_SIZE = 32

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
				var cursor_pos = get_node("cursor").global_position
				if event.is_action("ui_right") :
					cursor_pos.x += CURSOR_SIZE
				elif event.is_action("ui_left") :
					cursor_pos.x -= CURSOR_SIZE
				
				if event.is_action("ui_up") :
					cursor_pos.y -= CURSOR_SIZE
				elif event.is_action("ui_down") :
					cursor_pos.y += CURSOR_SIZE
				
				# Change cursor position
				if is_in_grid(cursor_pos) :
					get_node("cursor").global_position = cursor_pos

func _process(delta):
	pass

# To check if something is in the grid or not
func is_in_grid(var pos) :
	if pos.x >= self.global_position.x - GRID_SIZE / 2 and pos.x < self.global_position.x + GRID_SIZE / 2 and pos.y >= self.global_position.y - GRID_SIZE / 2 and pos.y < self.global_position.y + GRID_SIZE / 2 :
		return true
	
	return false

extends "state.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	pass
	
func _input(event):
	if event.is_pressed() :
		var cursor_pos = Vector2(0, 0)
		
		if event.is_action("ui_right") or event.is_action("ui_left") or event.is_action("ui_up") or event.is_action("ui_down"):
			if event.is_action("ui_right") :
				cursor_pos.x += 1
			elif event.is_action("ui_left") :
				cursor_pos.x -= 1
			if event.is_action("ui_up") :
				cursor_pos.y -= 1
			elif event.is_action("ui_down") :
				cursor_pos.y += 1
				
			self.target.pos += cursor_pos
			target.move(self.target.pos)
		
		print(target.get_unit_at_pos(target.pos))
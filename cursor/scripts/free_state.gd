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
		if event.is_action("ui_select"):
			var unit_under_cursor = target.get_unit_at_pos(target.pos)
			if unit_under_cursor != null:
				print(unit_under_cursor)
				state_machine.transition("select_target_state", unit_under_cursor)
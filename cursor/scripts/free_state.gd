extends "state.gd"

func _ready():
	pass

func _process(delta):
	pass
	
func _input(event):
	if event.is_pressed() :
		if event.is_action("ui_select"):
			var unit_under_cursor = target.get_unit_at_pos(target.pos)
			if unit_under_cursor != null:
				state_machine.transition("select_target_state", unit_under_cursor)
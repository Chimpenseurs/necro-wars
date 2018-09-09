extends "state.gd"

func _ready():
	pass

func _process(delta):
	pass
	
func _input(event):
	if event.is_pressed() :
		var next_pos = target.get_next_position(event)
		if next_pos != null:
			var cell = target.map.get_cellv(next_pos)
			if cell.type != "Bedrock":
				target.move(cell)

		if event.is_action("ui_select"):
			var unit_under_cursor = target.get_unit_at_pos(target.pos)
			if unit_under_cursor != null:
				state_machine.transition("own_target_selected", unit_under_cursor)
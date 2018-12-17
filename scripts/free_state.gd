extends "state.gd"

func _ready():
	pass

func _process(delta):
	pass
	
func _input(event):

		if event.is_action("ui_select"):
			var unit_under_cursor = target.get_unit_at_pos(target.pos)
			if unit_under_cursor != null:
				print("current group: ", target.player_id, " unit groups: ", unit_under_cursor.get_groups())
				if target.player_id in unit_under_cursor.get_groups():
					state_machine.transition("own_target_selected", unit_under_cursor)
			else:
				# Might be the good place to display ennemy range
				pass
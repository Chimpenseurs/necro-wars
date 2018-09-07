extends "state.gd"

var unit

func _ready():
	pass

func _input(event):
	if event.is_pressed() :
		if event.is_action("ui_cancel"):
			state_machine.transition("free_state", null)
		if event.is_action("ui_select"):
			if target.get_unit_at_pos(target.pos) == null:
				self.unit.move(target.pos)
				state_machine.transition("free_state", null)

func _process(delta):
	pass

func _on_enter_state(data):
	self.unit = data
	print("Unit selected: " + str(data))

func _on_leave_state(data):
	self.unit = null
	print("Unit de-selected: " + str(data))
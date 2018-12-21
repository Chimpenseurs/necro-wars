extends "state.gd"

const LevelApi = preload("res://scripts/LevelApi.gd")

var unit
var movement_zone
var attack_zone

func _position_changed():
	print(self.unit.movement)
	target.level.clear_zones()

	var movement_zone = target.level.dijkstra(
		self.unit.pos, 
		self.unit.movement
	)

	if movement_zone != null:
		self.movement_zone = movement_zone
		self.attack_zone = target.level.get_attack_range(movement_zone, self.unit.attack_range)

		target.level.display_circle(attack_zone)
		target.level.display_zone(movement_zone)
		
	print("Unit selected: " + str(unit))

func _input(event):
	if event.is_pressed() :

		if event.is_action("ui_cancel") :
			state_machine.transition("free_state", null)

		if event.is_action("ui_select"):
			if target.get_unit_at_pos(target.pos) == null:
				var cell = target.map.get_cellv(target.pos)

				if movement_zone.has(cell.pos):
					self.move_unit_to(target.pos)
					# state_machine.transition("free_state", null)

func move_unit_to(target_pos):
	var path = target.level.get_path_from_dijkstra(self.movement_zone, target_pos)
	self.unit.connect("finish_moving", self, "_position_changed", [], CONNECT_ONESHOT) 
	self.unit.move_to_target_with_path(path, target_pos)

func _on_enter_state(data):
	self.unit = data
	_position_changed()
	print("Unit selected: " + str(data))

func _on_leave_state(data):
	self.unit = null
	target.level.clear_zones()
	print("Unit de-selected: " + str(data))
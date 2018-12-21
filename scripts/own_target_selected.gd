extends "state.gd"

const LevelApi = preload("res://scripts/LevelApi.gd")

var unit
var movement_zone
# The zone with, but you may need to move the unit
var attack_zone_possible
# The direct zone, that can be access
var attack_zone_direct

func _position_changed():
	print(self.unit.movement)
	target.level.clear_zones()

	var movement_zone = target.level.dijkstra(
		self.unit.pos, 
		self.unit.movement
	)

	if movement_zone != null:
		self.movement_zone = movement_zone

		self.attack_zone_direct = target.level.get_attack_range(
			self.unit.pos, self.unit.attack_range)
	
		self.attack_zone_possible = target.level.get_attack_range_include_movement_range(
			movement_zone, self.unit.attack_range)

		target.level.display_zone(attack_zone_possible, "ACCESSIBLE")
		target.level.display_zone(attack_zone_direct,   "DIRECT")
		target.level.display_dijkstra_zone(movement_zone)
		
	print("Unit selected: " + str(unit))

func _input(event):
	if event.is_pressed() :

		if event.is_action("ui_cancel") :
			state_machine.transition("free_state", null)

		if event.is_action("ui_select"):
			var under_cusor = target.get_unit_at_pos(target.pos)
			var cell = target.map.get_cellv(target.pos)
			if under_cusor == null:
				if movement_zone.has(cell.pos):
					self.move_unit_to(target.pos)
					# state_machine.transition("free_state", null)
			elif under_cusor != null:
				if !target.player_id in under_cusor.get_groups():
					if attack_zone_direct.has(cell.pos):
						self.unit.attack(under_cusor)
						print("ayaaa")
				else:
					print("ally")

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
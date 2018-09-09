extends "state.gd"

const LevelApi = preload("res://common/scripts/LevelApi.gd")

var unit
var zone

func _ready():
	pass

func _input(event):
	if event.is_pressed() :

		var next_pos = target.get_next_position(event)
		if next_pos != null:
			var cell = target.map.get_cellv(next_pos)
			target.move(cell)

		if event.is_action("ui_cancel"):
			state_machine.transition("free_state", null)

		if event.is_action("ui_select"):
			if target.get_unit_at_pos(target.pos) == null:
				var cell = target.map.get_cellv(target.pos)

				if zone.has(cell.pos):
					self.unit.move(target.pos)
					state_machine.transition("free_state", null)

func _process(delta):
	pass

func _on_enter_state(data):
	self.unit = data

	var movement_zone = target.level.dijkstra(
		self.unit.pos, 
		self.unit.speed
	)

	if movement_zone != null:
		self.zone = movement_zone
		var att = target.level.get_attack_range(movement_zone, self.unit.attack_range)
		# target.level.display_zone_movement_and_range(att, self.unit.speed)
		target.level.display_zone(movement_zone)
		
	print("Unit selected: " + str(data))

func _on_leave_state(data):
	self.unit = null
	target.level.clear_zones()
	print("Unit de-selected: " + str(data))
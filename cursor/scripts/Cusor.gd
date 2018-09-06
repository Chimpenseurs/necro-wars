extends Node2D

const StateMachineFactory = preload("../../../addons/godot-finite-state-machine/state_machine_factory.gd")

# attributes of the cursor
var pos = Vector2(10, 0)
var map
var units
var conf

# please find another way
var tile_size

# Init state machine
var brain
const FreeState = preload("free_state.gd")
const SelectTargetState = preload("select_target_state.gd")
onready var smf = StateMachineFactory.new()

# Get sprite
onready var sprite = self.get_child(0)

func _ready():
	self.conf = self.get_parent().get_configuration()
	self.tile_size = conf["tile_size"]
	self.move(self.pos)
	brain = smf.create({
		"target": self,
		"current_state": "free_state",
		"states": [
			{"id": "free_state", "state": FreeState},
			{"id": "select_target_state", "state": SelectTargetState},
		],
		"transitions": [
			{"state_id": "free_state", "to_states": ["select_target_state"]},
			{"state_id": "select_target_state", "to_states": ["free_state"]},
		]
	})

func _process(delta): brain._process(delta)

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
				
			self.pos += cursor_pos
			self.move(pos)
			
	brain._input(event)

func set_map(map):
	self.map = map
	
func set_units(units):
	self.units = units

func get_unit_at_pos(pos):
	for unit in units:
		if unit.get_pos() == pos:
			return unit
	return null

func move(pos2d):
	self.position = pos2d * self.tile_size
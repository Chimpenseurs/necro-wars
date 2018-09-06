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
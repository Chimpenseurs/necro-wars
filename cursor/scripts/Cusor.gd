extends "../../player/scripts/abstract_player.gd".Player

const StateMachineFactory = preload("../../../addons/godot-finite-state-machine/state_machine_factory.gd")

# attributes of the cursor
var pos = Vector2(10, 0)

var map
var level
var units
var conf

# please find another way
var tile_size

# Init state machine
var brain

const FreeState         = preload("free_state.gd")
const OwnTargetSelected = preload("own_target_selected.gd")

onready var smf = StateMachineFactory.new()

# Get sprite
onready var sprite = self.get_child(0)

var camera

func _ready():
	self.level = self.get_parent()
	self.conf = level.get_configuration()
	self.map = level.get_map()

	camera = Camera2D.new()
	camera.set_name("Camera")
	camera.make_current()
	
	self.add_child(camera)
	
	var cell = map.get_cellv(self.position)
	self.move(cell)

	print(level.get_map())

	self.tile_size = conf["tile_size"]
	# self.move(self.pos)

	brain = smf.create({
		"target": self,
		"current_state": "free_state",
		"states": [
			{ "id": "free_state", "state": FreeState },
			{ "id": "own_target_selected", "state": OwnTargetSelected },
		],
		"transitions": [
			{"state_id": "free_state", "to_states": ["free_state", "own_target_selected"]},
			{"state_id": "own_target_selected", "to_states": ["free_state"]},
		]
	})

func _physics_process(delta): 
	pass

func set_inactive():
	self.set_process(false)
	self.set_process_input(false)
	self.hide()

func set_active():
	self.set_process(true)
	self.set_process_input(true)
	self.show()

func _process(delta):
	brain._process(delta)

func _input(event):

	if event.is_pressed() :
		var next_pos = self.get_next_position(event)
		if next_pos != null:
			var cell = self.map.get_cellv(next_pos)
			if cell.type != "Bedrock":
				self.move(cell)

		if event.is_action("end_turn"):
			level.end_turn(self)
			brain.transition("free_state", null)
			return
	brain._input(event)

func set_map(map):
	self.map = map

func set_level(level):
	self.level = level

func set_camera(camera):
	self.add_child(camera)

func set_units(units):
	self.units = units

func get_unit_at_pos(pos):
	for unit in units:
		if unit.get_pos() == pos:
			return unit
	return null
	
func move(cell):
	# Position in pixel
	self.position = cell.world_pos
	# Position in the map 
	self.pos = cell.pos

func get_next_position(event):

	var cursor_movement = Vector2(0, 0)
	if event.is_action("ui_right") or event.is_action("ui_left") or event.is_action("ui_up") or event.is_action("ui_down"):
		if event.is_action("ui_right") :
			cursor_movement.x += 1
		elif event.is_action("ui_left") :
			cursor_movement.x -= 1
		if event.is_action("ui_up") :
			cursor_movement.y -= 1
		elif event.is_action("ui_down") :
			cursor_movement.y += 1
		var next_pos = self.pos + cursor_movement

		return next_pos
	return null

func set_color(color):
	self.set_modulate(color)
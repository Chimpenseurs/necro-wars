extends Node2D

const StateMachineFactory = preload("../../../addons/godot-finite-state-machine/state_machine_factory.gd")

onready var smf = StateMachineFactory.new()

var pos = Vector2(10, 0)

var brain

onready var sprite = self.get_child(0)

func _process(delta): brain._process(delta)

func _ready():
	brain = smf.create({
		"target": self,
		"current_state": "idle",
		"states": [],
		"transitions": []
	})

func _input(event):
	brain._input(event)
	
	if event.is_pressed() :
		var cursor_pos = Vector2(0, 0)
		if event.is_action("ui_right") or event.is_action("ui_left") or event.is_action("ui_up") or event.is_action("ui_down"):
			if event.is_action("ui_right") :
				cursor_pos.x += 32
			elif event.is_action("ui_left") :
				cursor_pos.x -= 32
			if event.is_action("ui_up") :
				cursor_pos.y -= 32
			elif event.is_action("ui_down") :
				cursor_pos.y += 32
			
		self.translate( cursor_pos )
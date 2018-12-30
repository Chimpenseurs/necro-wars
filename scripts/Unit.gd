extends Node2D

signal finish_moving

const LevelApi = preload("res://scripts/LevelApi.gd")

var stats = {
	"life": 100,
	# Base stats are the stats dependent of the turn
	# and are reseted at each begining of a new turn
	"base_movement": 4,
	"base_action_point": 1,

	"attack_range": 1,
	"damage": 50,
	"unit_type": "Ground",
}


var pos = Vector2(0, 0)
var action_point
var movement
var attack_range
var type
var life

var is_moving = false
var path = []

var speed_animation = 1/5
var wait = 0

func _init_stats(stats):
	self.life = stats.life
	self.type = stats.unit_type
	self.attack_range = stats.attack_range
	self.action_point = stats.base_action_point

func init_for_new_turn():
	self.movement = stats.base_movement
	self.action_point = stats.base_action_point

func _ready():
	self._init_stats(stats)
	self.init_for_new_turn()

	self.pos = self.position / 32

func get_pos():
	return pos

func die():
	self.queue_free()

func attack(target_unit):
	if action_point == 0:
		print("can't attack, not more action point...")
		return

	self.action_point = self.action_point - 1
	
	target_unit.life = max(target_unit.life - self.stats.damage, 0)
	if target_unit.life == 0:
		target_unit.die()

func _process(delta):
	if is_moving:
		if wait <= 0:
			wait = speed_animation
			var next = path.pop_back()
			if next == null:
				self.is_moving = false
				self.emit_signal("finish_moving")
			else:
				movement -= LevelApi.cell_distance(next, self.type)
				self.move(next.pos)
		else:
			wait -= delta

func move(pos):
	self.position = pos * 32

func move_to_target_with_path(path, pos):
	self.is_moving = true
	path.pop_back() #The last is the current position
	self.path = path
	self.pos = pos


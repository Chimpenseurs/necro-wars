extends Node2D

signal finish_moving

var stats = {
	"movement": 4,
	"attack_range": 1
}

var pos = Vector2(0, 0)
var movement # TODO : separate speed and move range
var attack_range 

var is_moving = false
var path = []

var speed_animation = 1/1.5
var wait = 0

func _init_stats(stats):
	self.attack_range = stats.attack_range

func init_for_new_turn():
	self.movement = stats["movement"]

func _ready():
	self._init_stats(stats)
	self.init_for_new_turn()

	self.pos = self.position / 32

func get_pos():
	return pos

func _process(delta):
	if is_moving:
		if wait <= 0:
			wait = speed_animation
			var next = path.pop_back()
			if next == null:
				self.is_moving = false
				self.emit_signal("finish_moving")
			else:
				movement -= 1
				self.move(next)
		else:
			wait -= delta

func move(pos):
	self.position = pos * 32

func move_to_target_with_path(path, pos):
	self.is_moving = true
	path.pop_back() #The last is the current position
	self.path = path
	self.pos = pos


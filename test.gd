tool

extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var ar1 = [ 3 ]
var ar2 = [ 2, 1]
func _ready():
	print(ar2 + ar1)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

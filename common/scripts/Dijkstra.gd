class Dcell:
	var cell
	var distance
	
	func _init(cell, d):
		self.cell = cell
		self.distance = d

class Cell:
	var pos
	var speed

	func _init(p, d):
		self.pos = p
		self.speed = d
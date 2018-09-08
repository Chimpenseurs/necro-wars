const INFINITY = -1
const BLOCK    = -2

static func cell_distance(cell, unit_type):
	if unit_type == "Ground":
		# The mood slows the ground unit
		if cell.type == "Mood": return 2
		# Ground is fine
		if cell.type == "Ground": return 1
		if cell.type == "Pathway": return 0.75
		if cell.type == "Bedrock" or cell.type == "Obstacle" or cell.type == "Water" :
			return BLOCK
		return 1

class Dcell:
	var cell
	var distance
	
	func _init(cell, d):
		self.cell = cell
		self.distance = d

class Cell:
	var pos
	var type

	func _init(p, type):
		self.pos = p
		self.type = type
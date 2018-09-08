extends TileMap


onready var layer1 = get_node("Layer1")

# Information zones
onready var zones = get_node("Zones")

func _ready():
	# Gently reminder
	print(self.map_to_world(Vector2(1, 0)))
	print(self.world_to_map(Vector2(32, 0)))

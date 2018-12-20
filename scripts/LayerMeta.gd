extends TileMap

var name_to_id = {}

func _ready():
	var ids = self.tile_set.get_tiles_ids()
	print(str(self.get_meta_list()))
	for id in ids:
		var name = self.tile_set.tile_get_name(id)
		print(id, " ", name)
		name_to_id[id] = name

func get_cell_type(pos):
	var cell = self.get_cellv(pos)
	if cell == self.INVALID_CELL:
		return null
	return name_to_id[cell]
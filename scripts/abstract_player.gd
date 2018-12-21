class Player extends Node2D:
	
	var player_id = "neutral"
	
	func set_inactive(): pass
	func set_active(): pass
	func end_turn(): print("end turn")
	func player_init_turn():
		var my_group_members = get_tree().get_nodes_in_group(player_id)
		for unit in my_group_members:
			unit.init_for_new_turn()
			print("l", player_id)
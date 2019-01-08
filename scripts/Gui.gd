extends CanvasLayer

func update_turn_counter(count):
	$TurnCounter.text = "Turn: " + str(count)
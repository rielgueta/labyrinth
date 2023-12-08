extends Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	start()


func _on_game_over():
	stop()

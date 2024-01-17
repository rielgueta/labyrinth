extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_player_e():
	visible = not visible


func _on_button_button_down():
	print("Bruh")

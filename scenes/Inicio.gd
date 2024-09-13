extends MarginContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	$Contenido/opciones/StartButton.grab_focus()

func start_button_pressed():
	get_tree().change_scene_to_file("res://scenes/Game.tscn")



func presiona_controles():
	get_tree().change_scene_to_file("res://scenes/Controles.tscn")

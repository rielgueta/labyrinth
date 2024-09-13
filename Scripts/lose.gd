extends Control


func _ready():
	$Button.grab_focus()


func _on_button_button_up():
	get_tree().change_scene_to_file("res://scenes/Inicio.tscn")

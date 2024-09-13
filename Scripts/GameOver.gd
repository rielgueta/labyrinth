extends Control


func _ready():
	$BackToMenu.grab_focus()

func _on_back_to_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/Inicio.tscn")

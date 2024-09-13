extends Control


func _ready():
	$VBoxContainer/VBoxContainer/StartButton.grab_focus()


func presiona_controles():
	get_tree().change_scene_to_file("res://scenes/Controles.tscn")


func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://scenes/Game.tscn")

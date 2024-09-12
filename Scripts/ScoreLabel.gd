extends Label

var seconds = 0
var minutes = 0
var deci_sec = 0
var texto = ["00", "00", "00"]

var update = true

signal change_scene_game_over

@onready var global = get_node("/root/Global")

func _ready():
	update = true


func _on_game_over():
	print("HOLA")
	update = false
	global.score = texto
	print(texto)
	change_scene_game_over.emit()



func decisecond_passed():
	if update:
		# Revisar si efectivamente es un decisegundo, pq al menos en mi compu es como 0.5 no 0.1
		deci_sec += 1
		if deci_sec >= 10:
			seconds += 1
			deci_sec -= 10
		if seconds >= 60:
			minutes += 1
			seconds -= 60
		texto = [str(minutes), str(seconds), str(deci_sec)]
		if len(texto[0]) == 1:
			texto[0] = "0"+texto[0]
		if len(texto[1]) == 1:
			texto[1] = "0"+texto[1]
			
		text = texto[0]+":"+texto[1]+"."+texto[2]

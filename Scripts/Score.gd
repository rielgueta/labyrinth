extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	var global = get_node("/root/Global")
	text = global.score[0]+":"+global.score[1]+"."+global.score[2]

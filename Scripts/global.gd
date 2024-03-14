extends Node

var score = ["00", "00", "0"]

var items

func _ready():
	items = read_from_JSON("res://Scripts/items.json")
	for key in items.keys():
		items[key]["key"] = key

func read_from_JSON(path):
	var file = FileAccess.open(path, FileAccess.READ)
	var json = JSON.new()
	json.parse(file.get_as_text())
	return json.data

func get_item_by_key(key):
	if items and items.has(key):
		return items[key].duplicate(true)

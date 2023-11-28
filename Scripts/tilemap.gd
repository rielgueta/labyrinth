extends TileMap

# Un diccionario con las coordenadas de las tiles correspondientes



# Called when the node enters the scene tree for the first time.
func _ready():
	for fila in range(8):
		for columna in range(8):
			var x = randi_range(0, 3)
			var y = randi_range(0,3)
			set_cell(0, Vector2i(columna, fila), 0, Vector2i(x, y))




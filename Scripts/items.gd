extends TileMapLayer

var arriba = 0
var izquierda = 1
var abajo = 2
var derecha = 3


func generar_mapa_items(ancho_laberinto, sed=0):
	# Inicializamos la semilla para el laberinto
	# var sed = 2285957176
	# var sed = randi()
	var tamaño_mapa = ancho_laberinto * 2
	
	for i in range(0, tamaño_mapa, 1):
		for j in range(0, tamaño_mapa, 1):
			 #Asignar un item random a la celda
			var n_aleatorio = randi_range(1, 100)
			
			if n_aleatorio >= 80:
				n_aleatorio = randi_range(1, 100)
				if n_aleatorio >= 65:
					set_cell(Vector2i(i, j), 4, Vector2i(4, 0))
				elif n_aleatorio >= 25:
					set_cell(Vector2i(i, j), 4, Vector2i(2, 0))
				else:
					set_cell(Vector2i(i, j), 4, Vector2i(1, 0))

func tipo_item(coords:Vector2i):
	var index_item = get_cell_atlas_coords(coords)
	
	
	if index_item.x == 4 or index_item.x == 3:
		set_cell(coords, 4, Vector2i(3, 0))
	else:
		set_cell(coords, 4, Vector2i.ZERO)
	
	return index_item.x

func create_2d_array(width, height, value):
	var a = []

	for y in range(height):
		a.append([])
		a[y].resize(width)

		for x in range(width):
			a[y][x] = value

	return a

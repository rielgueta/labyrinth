extends TileMap

# Un diccionario con las coordenadas de las tiles correspondientes

@export var ancho_laberinto = 8
var arriba = 0
var izquierda = 1
var abajo = 2
var derecha = 3
# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(0, 8 , 1):
		for j in range(0, 8, 1):
			var posicion = asignar_movimientos(i, j)
			set_cell(0, Vector2i(i, j), 0, posicion)
			
			
			# set_cell(0, Vector2i(columna, fila), 0, Vector2i(x, y))

func asignar_movimientos(x, y):
	var movimientos = [false, false, false, false]

	if x != 0:
		var cell_izq = get_cell_atlas_coords(0, Vector2i(x - 1, y))
		if get_moves(cell_izq)[derecha]:
			movimientos[izquierda] = true

	if y != 0:
		var cell_arr = get_cell_atlas_coords(0, Vector2i(x, y - 1))
		if get_moves(cell_arr)[abajo]:
			movimientos[arriba] = true

		# Para eso contamos la cantidad de conexiones que queremos que tenga
		# random.choices se le entrega una lista de posibles resultados y una lista de la probabildad de cada uno
	# var cantidad_de_conexiones = random.choices([1, 2, 3, 4], [0.2, 0.5, 0.25, 0.05])
	var cantidad_de_conexiones = randi_range(1, 4)

		# Posteriormente contamos la cantidad actual de conexiones que se tienen, considerando las que estaban
		# determinadas por casillas anteriores
	var cantidad_actual = 0
	for i in range(0, 4, 1):
		if movimientos[i]:
			cantidad_actual += 1

		# Si la cantidad actual es menor a la cantidad total que queremos, se le agregará al azar una abertura hacia
		# abajo o hacia la derecha
		if cantidad_actual < cantidad_de_conexiones:
			var pos = randi_range(abajo, derecha)
			movimientos[pos] = true
			cantidad_actual += 1

		# Si todavía queda posibilidad (Sea porque habían 4 caminos) se agregará una abertura hacia el ultimo lado
			if cantidad_actual < cantidad_de_conexiones:

				# Notese que este comando (pos = 5-pos) se encarga de transformar la posición anterior a la otra disponible
				# (Entre las opciones 2 y 3). Si anteriormente se eligió la puerta 2 -> 5 - 2 = 3. Y viceversa
				# Si anteriormente se eligió la 3 -> 5 - 3 = 2. Así nos aseguramos que se eligirá la otra puerta disponible
				pos = 5 - pos
				movimientos[pos] = true

		# Estos comandos simplemente se encargan de eliminar las puertas que puedan haber quedado en la orilla derecha
		# y abajo
	if x == ancho_laberinto - 1:
		movimientos[derecha] = false

	if y == ancho_laberinto - 1:
		movimientos[abajo] = false
	
	var posicion = convert_to_cell(movimientos)
	
	return posicion

func get_moves(cell=Vector2i.ZERO):
	var movimientos = [false, false, false, false]
	
	if cell.y == 1 or cell.y == 3:
		movimientos[arriba] = true
	if cell.y == 2 or cell.y == 3:
		movimientos[izquierda] = true
	if cell.x == 1 or cell.x == 3:
		movimientos[abajo] = true
	if cell.x == 2 or cell.x == 3:
		movimientos[derecha] = true
	
	return movimientos
	
func convert_to_cell(movimientos):
	var posicion = Vector2i.ZERO
	
	if movimientos[0]:
		posicion.y += 1
	if movimientos[1]:
		posicion.y += 2
	if movimientos[2]:
		posicion.x += 1
	if movimientos[3]:
		posicion.x += 2

	return posicion

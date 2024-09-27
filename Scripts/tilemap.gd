extends TileMapLayer

# Variable del ancho del laberinto
@export var tamaño_laberinto = 8
var arriba = 0
var izquierda = 1
var abajo = 2
var derecha = 3

var aguas = create_2d_array(tamaño_laberinto, tamaño_laberinto,0)

# Called when the node enters the scene tree for the first time.
# HEY, ESTA FUNCIÓN NO HACE NADA???, PERO SE VE COMO ALGO QUE SOLERÍA HACER ALGO
# QUIZÁ DEBERIA TENER COSAS COMO LAS VARIABLES LOCALES? NO SE
func _ready():
	# generar_laberinto(tamaño_laberinto)
	pass

func generar_laberinto(ancho_laberinto: int, sed : int  = 0):
	# Inicializamos la semilla para el laberinto
	# var seed = 2285957176
	# var seed = randi()
	tamaño_laberinto = ancho_laberinto
	
	# Se crea un mapa de "aguas", que es un tablero con "0"s
	aguas = create_2d_array(tamaño_laberinto, tamaño_laberinto, 0)
	
	if sed != 0:
		seed(sed)
	else:
		seed(randi())
	print(sed)
	
	# Se recorre todo el tablero
	for i in range(0, ancho_laberinto, 1):
		for j in range(0, ancho_laberinto, 1):
			# A cada casilla del tablero se le asignan sus correspondientes movimientos
			var posicion = asignar_movimientos(i, j)
			# Se setea la casilla según la posición en la que se encuentra y su 
			# correspondiente en la cuadricula de tipos de casilla. 
			set_cell(Vector2i(i, j), 2, posicion)
	
	# Adelante está la lógica que permite revisar que el laberinto esté absolutamente conexo. 
	
	# Se inicia la funcíón aguas en la esquina arriba a la izquierda
	# para más información ver agua()
	aguas = agua(0, 0)
	# Se recorre todo el laberinto chequeando que cada zona tenga agua.
	for i in range(0, tamaño_laberinto, 1):
		for j in range(0, tamaño_laberinto, 1):
			# En caso de encontrar una zona sin agua, se 'arregla' // se destruye una pared
			# para permitir el paso de agua y se vuelve a chequear
			if aguas[i][j] == 0:
				arreglar(i, j)
				aguas = agua(i, j)

func asignar_movimientos(x: int, y: int) -> Vector2i:
	"""Función que le asigna los movimientos disponibles a cada casilla
	Funciona creando conexiones hacia la derecha y hacia abajo de cada casilla. Además chequea
	que la casilla la izquierda y arriba tengan sus puertas abiertas, en ese caso se conectan."""
	
	# Se crea una lista con los posibles movimientos a celdas cercanas. 
	var movimientos = [false, false, false, false]
	
	# Se revisa que la celda no sea la primera de la fila (Para poder acceder a la fila a la izq.)
	if x != 0:
		# Revisa si la celda de la izquierda está conectada con la actual,
		# si es así, declara que está conectada
		var cell_izq = get_cell_atlas_coords(Vector2i(x - 1, y))
		# Se chequea que la celda de la izquierda contenga una apertura a la derecha
		if get_moves(cell_izq, derecha):
			# En ese caso, se abre esta misma abertura en la celda actual
			movimientos[izquierda] = true

	# Lo mismo pero para las columnas
	if y != 0:
		var cell_arr = get_cell_atlas_coords(Vector2i(x, y - 1))
		if get_moves(cell_arr, abajo):
			movimientos[arriba] = true

	# A continuación, el algoritmo que crea nuevas salidas para la celda
	
	# ESTAS PROBABILIDADES ESTÁN MAL Y HAY QUE ORDENARLAS
	# 4/20 1 conexion
	# 10/20 2 conexiones
	# 8/20 3 conexiones
	# 1/20 4 conexiones
	
	# Decide cuantas conexiones totales se quieren tener en la casilla.
	var n_aleatorio = randi_range(1, 110)
	var cantidad_de_conexiones = 1
	if n_aleatorio >= 45:
		cantidad_de_conexiones += 1
	if n_aleatorio >= 60:
		cantidad_de_conexiones += 1
	if n_aleatorio >= 106:
		cantidad_de_conexiones += 1

	# Posteriormente contamos la cantidad actual de conexiones que se tienen,
	#  considerando las que estaban determinadas por casillas anteriores.
	var cantidad_actual = 0
	for i in range(0, 4, 1):
		if movimientos[i]:
			cantidad_actual += 1

		# Si la cantidad actual es menor a la cantidad total que queremos, 
		# se le agregará al azar una abertura hacia abajo o hacia la derecha
		if cantidad_actual < cantidad_de_conexiones:
			var pos = randi_range(abajo, derecha)
			movimientos[pos] = true
			cantidad_actual += 1

		# Si todavía queda posibilidad (Sea porque habían 4 caminos) 
		# se agregará una abertura hacia el ultimo lado
			if cantidad_actual < cantidad_de_conexiones:
				# Notese que este comando (pos = 5-pos) se encarga de transformar la posición
				# anterior a la otra disponible (Entre las opciones 2 y 3). 
				# Si anteriormente se eligió la puerta 2 -> 5 - 2 = 3. Y viceversa
				# Si anteriormente se eligió la 3 -> 5 - 3 = 2.
				# Así nos aseguramos que se eligirá la otra puerta disponible
				pos = 5 - pos
				movimientos[pos] = true

	# Estos comandos simplemente se encargan de eliminar las puertas que puedan
	# haber quedado en la orilla derecha y de abajo
	if x == tamaño_laberinto - 1:
		movimientos[derecha] = false

	if y == tamaño_laberinto - 1:
		movimientos[abajo] = false
	
	# Convierte los movimientos a una posición en el tablero de tipos de celdas.
	var posicion = convert_to_cell(movimientos)
	return posicion

# NO PUSE QUE RETORNA PORQUE TIENE 2 TIPOS DE RETURN
func get_moves(cell: Vector2i, direccion: int = -1):
	"""Función que se encarga de recibir el tipo de celda y retornar
	Opción 1- Sus posibles movimientos, si es que no se asigna una dirección
	Opción 2- Apertura de la dirección seleccionada"""
	
	# Array que guarda las conexiones asociadas a una coordenada del Atlas
	var movimientos = [false, false, false, false]
	
	# Se asignan los movimientos según la posición que ocupen en el Atlas de tipos de coordenadas.
	if cell.y == 1 or cell.y == 3:
		movimientos[arriba] = true
	if cell.y == 2 or cell.y == 3:
		movimientos[izquierda] = true
	if cell.x == 1 or cell.x == 3:
		movimientos[abajo] = true
	if cell.x == 2 or cell.x == 3:
		movimientos[derecha] = true
	
	# Si se le especifica una coordenada, solamente retorna esa
	if direccion == -1:
		return movimientos
	else:
		return movimientos[direccion]

func obtener_posiciones(coord: Vector2i) -> Array:
	"""Función intermedia que extrae los posibles movimientos de una casilla.
	Ocupada para escenas externas"""
	return get_moves(get_cell_atlas_coords(coord))

func convert_to_cell(movimientos) -> Vector2i:
	"""Función que dada una lista de conexiones de una casilla, retorna el vector
	que indica la posición de ese tipo de casillas en el Atlas de casillas"""
	
	var posicion = Vector2i.ZERO
	
	# Se asignan las posiciones del vector según un método. 
	if movimientos[0]:
		posicion.y += 1
	if movimientos[1]:
		posicion.y += 2
	if movimientos[2]:
		posicion.x += 1
	if movimientos[3]:
		posicion.x += 2

	return posicion

func agua(x, y):
	"""Función recursiva. Se encarga de chequear que todo el laberinto se encuentre lleno mediante
	la lógica del agua (Un laberinto abierto siempre podra ser resuelto 'inundandolo').
	Se encarga de recibir una casilla y rellenarla con agua, posteriormente se llama a si misma
	en alguna casilla adyacente a la que pueda recorrer, se detiene al encontrar una casilla que
	ya haya sido llenada"""
	
	if aguas[x][y] == 1:
		return
	
	aguas[x][y] = 1
	
	# Recibe los movimientos posibles de la casilla en la que se encuentra
	var cell = get_cell_atlas_coords(Vector2i(x, y))
	var movimientos = get_moves(cell)
	
	# Intenta acceder a cada una de las casillas adyacentes para ejecutar agua()
	for i in range(0, 4, 1):
		if movimientos[i]:
			if i == 0:
				agua(x, y - 1)
			elif i == 1:
				agua(x - 1, y)
			elif i == 2:
				agua(x, y + 1)
			else:
				agua(x + 1, y)
	
	# Una vez termina la recursividad, simplemente retorna el mapa de aguas. 
	return aguas

func arreglar(x, y):
	"""Función que se encarga de modificar el laberinto si se encuentra una desconexión"""
	
	# Se extraen los datos de la casilla actual.
	var cell = get_cell_atlas_coords(Vector2i(x, y))
	var movimientos = get_moves(cell)
	
	# Si la casilla no se encuentra en la fila de la izquierda, se cambia la casilla a su izquierda
	if x != 0:
		var cell_izq = get_cell_atlas_coords(Vector2i(x - 1, y))
		var movimientos_izq = get_moves(cell_izq)
		
		# Se modifican los datos de esta casilla y la de la izquierda
		movimientos[izquierda] = true
		movimientos_izq[derecha] = true
		
		# Se cambia la casilla de la izquierda
		var posicion_izq = convert_to_cell(movimientos_izq)
		set_cell(Vector2i(x - 1, y), 2, posicion_izq)
	# Misma lógica pero con la casilla de arriba
	else:
		var cell_arr = get_cell_atlas_coords(Vector2i(x, y - 1))
		var movimientos_arr = get_moves(cell_arr)
		
		movimientos[arriba] = true
		movimientos_arr[abajo] = true
		
		var posicion_arr = convert_to_cell(movimientos_arr)
		set_cell(Vector2i(x, y - 1), 2, posicion_arr)
	
	# Finalmente se arregla la casilla actual. 
	var posicion = convert_to_cell(movimientos)
	set_cell(Vector2i(x, y), 2, posicion)

func modificar_celda(coordenadas, direccion):
	"""Función que se encarga de modificar celdas por cualquier eventualidad.
	Se suele ocupar para generar la salida a parte."""
	
	# Se extraen los movimientos de la celda a modificar.
	var celda_a_mod = get_cell_atlas_coords(coordenadas)
	var mov = get_moves(celda_a_mod)
	
	# Se modifica la dirección seleccionada
	mov[direccion] = true
	
	# Y se cambia el tipo de celda.
	var coord_atlas = convert_to_cell(mov)
	set_cell(coordenadas, 2, coord_atlas)

func create_2d_array(width, height, value) -> Array:
	
	var a = []

	for y in range(height):
		a.append([])
		a[y].resize(width)

		for x in range(width):
			a[y][x] = value

	return a

extends TileMap

# Variable del ancho del laberinto
@export var tamaño_laberinto = 8
var arriba = 0
var izquierda = 1
var abajo = 2
var derecha = 3

var aguas = create_2d_array(tamaño_laberinto, tamaño_laberinto,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	generar_laberinto(tamaño_laberinto)

func generar_laberinto(ancho_laberinto, sed=0):
	# Inicializamos la semilla para el laberinto
	# var sed = 2285957176
	# var sed = randi()
	tamaño_laberinto = ancho_laberinto
	
	aguas = create_2d_array(tamaño_laberinto, tamaño_laberinto,0)
	if sed:
		seed(sed)
	else:
		seed(randi())
		
	seed(sed)
	print(sed)
	
	for i in range(0, ancho_laberinto, 1):
		aguas.append([])
		for j in range(0, ancho_laberinto, 1):
			var posicion = asignar_movimientos(i, j)
			aguas[i].append(0)
			set_cell(0, Vector2i(i, j), 0, posicion)

			
	aguas = agua(0, 0)
	for i in range(0, tamaño_laberinto, 1):
		for j in range(0, tamaño_laberinto, 1):
			if aguas[i][j] == 0:
				arreglar(i, j)
				aguas = agua(i, j)
	
	modificar_celda(Vector2i(ancho_laberinto-1, ancho_laberinto-1), abajo)

func asignar_movimientos(x, y):
	# Conexiones con las celdas cercanas
	var movimientos = [false, false, false, false]

	# Si no es la primera fila
	if x != 0:
		# Revisa si la celda de la izquierda está conectada con la actual, si es así, declara que está conectada
		var cell_izq = get_cell_atlas_coords(0, Vector2i(x - 1, y))
		if get_moves(cell_izq,derecha):
			movimientos[izquierda] = true

	# Lo mismo pero para las columnas
	if y != 0:
		var cell_arr = get_cell_atlas_coords(0, Vector2i(x, y - 1))
		if get_moves(cell_arr, abajo):
			movimientos[arriba] = true

	# Para eso contamos la cantidad de conexiones que queremos que tenga
	# 4/20 1 conexion
	# 10/20 2 conexiones
	# 8/20 3 conexiones
	# 1/20 4 conexiones
	var n_aleatorio = randi_range(1, 100)
	var cantidad_de_conexiones = 1
	if n_aleatorio >= 36:
		cantidad_de_conexiones += 1
	if n_aleatorio >= 76:
		cantidad_de_conexiones += 1
	if n_aleatorio >= 96:
		cantidad_de_conexiones += 1

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
	if x == tamaño_laberinto - 1:
		movimientos[derecha] = false

	if y == tamaño_laberinto - 1:
		movimientos[abajo] = false
	
	var posicion = convert_to_cell(movimientos)
	return posicion

func get_moves(cell: Vector2i, direccion=-1):
	# Array que guarda las conexiones asociadas a una coordenada del Atlas
	var movimientos = [false, false, false, false]
	
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
	
func convert_to_cell(movimientos):
	# Dada una lista con las conexiones posibles, retorna el ID de la celda asociada
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

func agua(x, y):
	if aguas[x][y] == 1:
		return
	
	aguas[x][y] = 1
	
	
	var cell = get_cell_atlas_coords(0, Vector2i(x, y))
	var movimientos = get_moves(cell)
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
	return aguas

func arreglar(x, y):
	# Arregla el laberinto para que esté interconectado
	var cell = get_cell_atlas_coords(0, Vector2i(x, y))
	var movimientos = get_moves(cell)
	
	if x != 0:
		var cell_izq = get_cell_atlas_coords(0, Vector2i(x - 1, y))
		var movimientos_izq = get_moves(cell_izq)
		
		movimientos[izquierda] = true
		movimientos_izq[derecha] = true
		
		var posicion_izq = convert_to_cell(movimientos_izq)
		set_cell(0, Vector2i(x - 1, y), 0, posicion_izq)
	else:
		var cell_arr = get_cell_atlas_coords(0, Vector2i(x, y - 1))
		var movimientos_arr = get_moves(cell_arr)
		
		movimientos[arriba] = true
		movimientos_arr[abajo] = true
		
		var posicion_arr = convert_to_cell(movimientos_arr)
		set_cell(0, Vector2i(x, y - 1), 0, posicion_arr)
	
	var posicion = convert_to_cell(movimientos)
	set_cell(0, Vector2i(x, y), 0, posicion)

func modificar_celda(coordenadas, modificador):
	var celda_a_mod = get_cell_atlas_coords(0, coordenadas)
	var mov = get_moves(celda_a_mod)
	mov[modificador] = true
	var coord_atlas = convert_to_cell(mov)
	set_cell(0,coordenadas, 0, coord_atlas)
	
func create_2d_array(width, height, value):
	var a = []

	for y in range(height):
		a.append([])
		a[y].resize(width)

		for x in range(width):
			a[y][x] = value

	return a

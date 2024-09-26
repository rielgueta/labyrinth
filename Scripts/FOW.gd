extends TileMapLayer

# Variable del ancho del laberinto
@export var tamaño_laberinto = 8
var arriba = 0
var izquierda = 1
var abajo = 2
var derecha = 3


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

func revelar(coords:Vector2i, movs:Array):
	var movimientos = movs
	erase_cell(coords-Vector2i.ZERO)
	
	for i in range(0, 4, 1):
		if movimientos[i]:
			if i == 0:
				erase_cell(coords + Vector2i.UP)
			elif i == 1:
				erase_cell(coords + Vector2i.LEFT)
			elif i == 2:
				erase_cell(coords + Vector2i.DOWN)
			else:
				erase_cell(coords + Vector2i.RIGHT)

func generar_fow(ancho):
	for i in range(ancho):
		for j in range(ancho):
			set_cell(Vector2i(i, j), 3, Vector2i.ZERO)

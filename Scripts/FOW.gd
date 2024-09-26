extends TileMapLayer

@onready var global = get_node("/root/Global")


func get_moves(cell: Vector2i, direccion=-1):
	# Array que guarda las conexiones asociadas a una coordenada del Atlas
	var movimientos = [false, false, false, false]
	
	if cell.y == 1 or cell.y == 3:
		movimientos[global.UP] = true
	if cell.y == 2 or cell.y == 3:
		movimientos[global.LEFT] = true
	if cell.x == 1 or cell.x == 3:
		movimientos[global.DOWN] = true
	if cell.x == 2 or cell.x == 3:
		movimientos[global.RIGHT] = true
	# Si se le especifica una coordenada, solamente retorna esa
	if direccion == -1:
		return movimientos
	else:
		return movimientos[direccion]


func revelar(coords:Vector2i, movs:Array):
	erase_cell(coords-Vector2i.ZERO)
	
	for i in range(0, 4, 1):
		if movs[i]:
			if i == global.UP:
				erase_cell(coords + Vector2i.UP)
			elif i == global.LEFT:
				erase_cell(coords + Vector2i.LEFT)
			elif i == global.DOWN:
				erase_cell(coords + Vector2i.DOWN)
			else:
				erase_cell(coords + Vector2i.RIGHT)


func generar_fow(ancho):
	for i in range(ancho):
		for j in range(ancho):
			set_cell(Vector2i(i, j), 3, Vector2i.ZERO)

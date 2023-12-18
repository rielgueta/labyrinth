extends TileMap

func esconder(ancho):
	for i in range(ancho):
		for j in range(ancho):
			set_cell(3, Vector2i(i, j), 0, Vector2i.ZERO)

func mostrar(coords:Vector2i):
	erase_cell(3, Vector2i(coords)-Vector2i(1,0))

extends Node2D
var grid_size = 32
var walk_trough_walls = false
var vida = 20
var hambre = 7

signal moved
# comentadas por si las utilizamos en el futuro
#func _ready():
#	$Sprite2D.show()
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _unhandled_key_input(event):
	# Cuando se presiona una tecla, revisa la dirección en la cuál se debería mover y llama a la funcón mover
	# Es cuando se suelta la tecla para que solo se mueva una celda
	var direction = Vector2.ZERO
	if event.is_action_released("ui_up"):
		direction.y = -1
		move(direction)
	if event.is_action_released("ui_down"):
		direction.y = 1
		move(direction)
	if event.is_action_released("ui_left"):
		direction.x = -1
		move(direction)
	if event.is_action_released("ui_right"):
		direction.x = 1
		move(direction)
	if event.is_action_released("DEBUG"):
		walk_trough_walls = not walk_trough_walls

func move(dir):
	# Lanza un "rayo laser" en la dirección en la que se quiere mover y si no colisiona con nada...
	$RayCast2D.target_position = dir*(grid_size*2-4)
	$RayCast2D.force_raycast_update()
	if not $RayCast2D.is_colliding() or walk_trough_walls:
		# Entonces se mueve una celda (El tamaño de la celda)
		position += dir*grid_size
		moved.emit()


var pocima = 1
var comida = 2
var trampa = 3

func interactuar(id_item):
	hambre -= 1
	
	if id_item == pocima:
		var curacion = randi_range(5, 8)
		vida += curacion
	elif id_item == comida:
		hambre = 7
	elif id_item == trampa:
		var daño = randi_range(3, 5)
		vida -= daño
	
	vida = min(vida, 20)
	
	if hambre <= 0:
		if hambre == 0:
			print("Empieza el hambreeee")
		if abs(hambre % 2) == 1:
			vida -= 1
		
	if vida <= 0:
		vida = 0
		print("Deberías haber muerto! (Pero como que no yet)")
	
	print("vidaaaaa : ", vida)
	var texto = ""
	for i in range(0, hambre, 1):
		texto += "⛻"
	print(texto)

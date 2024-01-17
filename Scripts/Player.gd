extends Node2D
var grid_size = 32
var walk_trough_walls = false

@export var vida_max = 20
var vida = vida_max

@export var hambre_maxima = 7
var hambre = hambre_maxima

var pocima = 1
var comida = 2
var trampa = 4    # Trust me bro, la 3 es la versión visible / desactivada

signal moved
signal lose
signal e
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
	if event.is_action_released("Inventario"):
		e.emit()


func move(dir):
	# Lanza un "rayo laser" en la dirección en la que se quiere mover y si no colisiona con nada...
	$RayCast2D.target_position = dir * (grid_size * 2 - 4)
	$RayCast2D.force_raycast_update()
	if not $RayCast2D.is_colliding() or walk_trough_walls:
		# Entonces se mueve una celda (El tamaño de la celda)
		position += dir * grid_size
		moved.emit()


func interactuar(id_item):
	# La función que se encarga de interactuar con los items del laberinto
	if not walk_trough_walls:
		hambre -= 1
	
		if id_item == pocima:
			var curacion = randi_range(5, 8)
			vida = min(vida+curacion, vida_max)
		elif id_item == comida:
			hambre = hambre_maxima
		elif id_item == trampa:
			print("MUAJAJA TRAMPA")
			var daño = randi_range(3, 5)
			vida -= daño

	if hambre <= 0:
		if hambre == 0:
			# MENSAJE DE TENÉS HAMBRE CHE
			pass
		# Descuenta 1 de vida cada 2 movimientos si tienes una vida inferior a 0
		if abs(hambre % 2) == 1:
			vida -= 1
		
	if vida <= 0:
		vida = 0
		get_tree().change_scene_to_file("res://scenes/lose.tscn")

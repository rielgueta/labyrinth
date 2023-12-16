extends Node2D
var grid_size = 16
var walk_trough_walls = false

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
	if event.is_action_released("ui_down"):
		direction.y = 1
	if event.is_action_released("ui_left"):
		direction.x = -1
	if event.is_action_released("ui_right"):
		direction.x = 1
	if event.is_action_released("DEBUG"):
		walk_trough_walls = not walk_trough_walls
	move(direction)

func move(dir):
	# Lanza un "rayo laser" en la dirección en la que se quiere mover y si no colisiona con nada...
	$RayCast2D.target_position = dir*(grid_size*2-4)
	$RayCast2D.force_raycast_update()
	if not $RayCast2D.is_colliding() or walk_trough_walls:
		# Entonces se mueve una celda (El tamaño de la celda)
		position += dir*grid_size
		moved.emit()

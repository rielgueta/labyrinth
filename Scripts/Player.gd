extends Node2D
var grid_size = 16

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _unhandled_key_input(event):
	var direction = Vector2.ZERO
	if event.is_action_released("ui_up"):
		direction.y = -1
	if event.is_action_released("ui_down"):
		direction.y = 1
	if event.is_action_released("ui_left"):
		direction.x = -1
	if event.is_action_released("ui_right"):
		direction.x = 1
	move(direction)

func move(dir):
	# TODO reemplazar condición por un raycast
	$RayCast2D.target_position = dir*16
	$RayCast2D.force_raycast_update()
	if not $RayCast2D.is_colliding():
		position += dir*grid_size

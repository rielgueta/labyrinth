extends Node2D

@onready var globals = get_node("/root/Global")

@export var ancho_laberinto = 8
@export var grid_size = 32

signal game_over


func _ready():
	globals.ANCHO_LAB = ancho_laberinto
	globals.GRID_SIZE = grid_size
	
	# Generamos el laberinto
	$Laberinto.generar_laberinto(globals.ANCHO_LAB)
	$Items.generar_mapa_items(globals.ANCHO_LAB)
	$Desconocido.generar_fow(globals.ANCHO_LAB)
	
	# Creamos la salida
	var direc_salida = randi_range(0, 3)
	# Salida es la coordenada del borde
	# Salida_2 es la otra coordenada, hacia donde la salida apunta. 
	var salida_cord_secundaria = randi_range(0, ancho_laberinto - 1)
	var salida_cord_primaria = (0 if direc_salida in [globals.UP, globals.LEFT] else ancho_laberinto - 1)
	
	var pos_sal = [salida_cord_secundaria, salida_cord_primaria]
	if direc_salida in [globals.LEFT, globals.RIGHT]:
		pos_sal = [salida_cord_primaria, salida_cord_secundaria]
	print(pos_sal)
	$Laberinto.modificar_celda(Vector2i(pos_sal[0], pos_sal[1]), direc_salida)
	$Salida.position = (Vector2i(pos_sal[0], pos_sal[1]) + globals.vectores[direc_salida])*grid_size
	#if direc_salida == globals.UP or direc_salida == globals.DOWN :
		#$Laberinto.modificar_celda(Vector2i(salida, salida_2), direc_salida)
		#$Salida.position = Vector2i(salida*grid_size, 
									#grid_size*(salida_2 + (direc_salida - 1)))
	#else:
		#$Laberinto.modificar_celda(Vector2i(salida_2, salida), direc_salida)
		#$Salida.position = Vector2i(salida_2*grid_size + grid_size * (direc_salida - 2), 
									#salida*grid_size)
	
	var pos = Vector2(randi_range(int(ancho_laberinto / 2) - 1, int(ancho_laberinto / 2) + 1),
	+				   randi_range(int(ancho_laberinto / 2) - 1, int(ancho_laberinto / 2) + 1))
	
	$Player.position += pos * grid_size
	pos = Vector2i(pos)
	# $Salida.position = Vector2i(salida*grid_size, ancho_laberinto*grid_size+6)
	$Desconocido.revelar(pos, $Laberinto.obtener_posiciones(pos))
	update_UI()

func _on_salida_body_entered(body):
	print("Salida")
	game_over.emit()
	

func _change_to_game_over():
	get_tree().change_scene_to_file("res://scenes/GameOver.tscn")


func _on_player_moved():
	var pos = $Player.position / grid_size
	$Desconocido.revelar(pos, $Laberinto.obtener_posiciones(pos))
	# Acá va el interactuar con el objeto.
	var id_item = $Items.tipo_item(($Player.position)/grid_size)
	$Player.interactuar(id_item)
	update_UI()

func update_UI():
	var vida = $Player.vida
	var hambre = $Player.hambre
	var hambre_text = ""
	$Player/Camera2D/UI/LifeLabel.text = "Vida: " + str(vida)
	for i in range(0, hambre, 1):
		hambre_text += "&"
	$Player/Camera2D/UI/HungerLabel.text = "Hambre: " + hambre_text

extends Node2D

@export var ancho_laberinto = 8
@export var grid_size = 32
signal game_over

func _ready():
	# Generamos el laberinto
	$Laberinto.generar_laberinto(ancho_laberinto)
	$Laberinto.esconder(ancho_laberinto)
	
	# Creamos la salida
	var salida = randi_range(0, ancho_laberinto-1)
	$Laberinto.modificar_celda(Vector2i(salida, ancho_laberinto-1), 2)
	$Salida.position = Vector2i(salida*grid_size, ancho_laberinto*grid_size+6)
	$Laberinto.mostrar(Vector2i.ZERO)

func _on_salida_body_entered(body):
	print("Salida")
	game_over.emit()
	

func _change_to_game_over():
	get_tree().change_scene_to_file("res://scenes/GameOver.tscn")


func _on_player_moved():
	$Laberinto.mostrar(($Player.position)/grid_size)
	# Acá va el interactuar con el objeto.
	var id_item = $Laberinto.tipo_item(($Player.position)/grid_size)
	$Player.interactuar(id_item)
	update_UI()

func update_UI():
	var vida = $Player.vida
	var hambre = $Player.hambre
	var hambre_text = ""
	$Player/Camera2D/UI/LifeLabel.text = "Vida: " + str(vida)
	for i in range(0, hambre, 1):
		hambre_text += "∆"
	$Player/Camera2D/UI/HungerLabel.text = "Hambre: " + hambre_text

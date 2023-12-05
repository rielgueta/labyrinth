extends Node2D

@export var ancho_laberinto = 8
@export var grid_size = 16

func _ready():
	$Salida.position = Vector2i((ancho_laberinto-1)*grid_size, ancho_laberinto*grid_size)
	$TileMap.generar_laberinto(ancho_laberinto)


func _on_salida_body_entered(body):
	print("Salida")

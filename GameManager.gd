extends Node

var briques_restantes: int = 0

func brique_detruite() -> void:
	briques_restantes -= 1
	print("Briques restantes : ", briques_restantes)
	if briques_restantes <= 0:
		print("Victoire déclenchée !")
		get_tree().call_deferred("change_scene_to_file", "res://Winner/winner.tscn")

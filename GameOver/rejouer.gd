extends Control

@onready var musique := $MusiqueFin
@onready var son_resultat := $SonResultat

func _ready() -> void:
	son_resultat.play()
	musique.play()

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")

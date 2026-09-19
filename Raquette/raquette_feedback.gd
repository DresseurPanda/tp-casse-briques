extends CharacterBody2D

@onready var anim_player := $AnimationPlayer

func jouer_flash() -> void:
	anim_player.play("flash")

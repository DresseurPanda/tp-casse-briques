extends Node

@export var vitesse: float = 400.0

@onready var son_deplacement := $SonDeplacement
@onready var son_bord := $SonBord

@onready var particules_gauche := get_parent().get_node("ParticulesGauche") as GPUParticles2D
@onready var particules_droite := get_parent().get_node("ParticulesDroite") as GPUParticles2D

func _physics_process(delta: float) -> void:
	var raquette := get_parent() as CharacterBody2D
	var sprite := raquette.get_node("Sprite2D") as Sprite2D
	var direction := Input.get_axis("p1_left", "p1_right")
	
	# Émet des particules du côté opposé au mouvement (effet "propulsion")
	particules_gauche.emitting = direction > 0  # va à droite → jet à gauche
	particules_droite.emitting = direction < 0  # va à gauche → jet à droite
	
	var position_voulue := raquette.position.x + direction * vitesse * delta
	raquette.position.x = position_voulue
	
	var largeur_ecran := get_viewport().get_visible_rect().size.x
	var demi_largeur_raquette: float = (sprite.get_rect().size.x * sprite.scale.x) / 2
	
	var position_clampee: float = clamp(
		position_voulue,
		demi_largeur_raquette,
		largeur_ecran - demi_largeur_raquette
	)
	
	# Si le clamp a modifié la position, c'est qu'on a touché un bord
	if position_clampee != position_voulue and direction != 0:
		if not son_bord.playing:
			son_bord.play()
	
	raquette.position.x = position_clampee
	
	if direction != 0:
		if not son_deplacement.playing:
			son_deplacement.play()
	else:
		son_deplacement.stop()

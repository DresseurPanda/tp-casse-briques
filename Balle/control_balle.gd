extends RigidBody2D

@export var vitesse_initiale: float = 300.0

var start := false

@onready var son_raquette := $SonRaquette
@onready var son_mur := $SonMur
@onready var son_brique := $SonBrique
@onready var anim_player := $AnimationPlayer


func _physics_process(_delta: float) -> void:
	if not start:
		linear_velocity = Vector2(0, vitesse_initiale)
		start = true
	else:
		var direction := linear_velocity.normalized()
		var angle_min := 0.2
		
		if abs(direction.x) < angle_min:
			direction.x = angle_min if direction.x >= 0 else -angle_min
			direction = direction.normalized()
		if abs(direction.y) < angle_min:
			direction.y = angle_min if direction.y >= 0 else -angle_min
			direction = direction.normalized()
		
		linear_velocity = direction * vitesse_initiale

func _on_body_entered(body: Node) -> void:
	anim_player.play("pulse")

	if body.is_in_group("raquette"):
		body.jouer_flash()
		son_raquette.play()
	elif body.is_in_group("mur"):
		son_mur.play()
	elif body.is_in_group("brique") or body.get_parent() and body.get_parent().is_in_group("brique"):
		son_brique.play()

extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("balle"):
		GameManager.brique_detruite()
		
		var brique := get_parent()
		var anim_player := brique.get_node("AnimationPlayer") as AnimationPlayer
		anim_player.play("destruction")
		await anim_player.animation_finished
		
		brique.queue_free()

extends Area2D

func _process(delta):
	$AnimatedSprite2D.play("default")

func _on_area_entered(area):
	if area.name == "player_hitbox":
		queue_free()

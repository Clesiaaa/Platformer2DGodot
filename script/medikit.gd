extends Area2D

func _on_area_entered(area):
	if area.name == "player_hitbox":
		queue_free()

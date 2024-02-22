extends CharacterBody2D

var speed = 60
var player_chase = false
var player = null
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	velocity.y += gravity * delta
	move_and_slide()
		
	if player_chase:
		position += (player.position - position)/speed

	move_and_slide()

func _on_detection_range_body_entered(body):
	player = body
	player_chase = true

func _on_detection_range_body_exited(body):
	player = null
	player_chase = false

func _on_monster_hitbox_area_entered(area):
	if area.name == "player_hitbox":
		queue_free()

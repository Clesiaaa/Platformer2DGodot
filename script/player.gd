extends CharacterBody2D

@export var speed = 300
@export var gravity = 30
@export var jump_force = 500

@onready var pause_menu = $PauseMenu
@onready var sprite = $AnimatedSprite2D
@onready var an = $AnimationPlayer

var flip_character = false
var health = 100
var money = 0      

var jump_max = 1
var jump_count = 0                                                     

var dashing = false
var can_dash = true

var paused = false

func _physics_process(delta):
	if Input.is_action_just_pressed("pause"):
		pausemenu()
	player_movements(delta)
	
func pausemenu():
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1
	else:
		pause_menu.show()
		Engine.time_scale = 0
		
	paused = !paused

func player_movements(delta):
	
	if !is_on_floor():
		velocity.y += gravity

		if velocity.y > 1000:
			velocity.y = 1000

	if jump_count < jump_max:
		if Input.is_action_just_pressed("jump"):
			velocity.y = -jump_force
			jump_count += 1

	if Input.is_action_just_pressed("dash") and can_dash:
		dashing = true
		can_dash = false
		speed = 730
		$dash.start()

	if is_on_floor() and jump_count != 0:
		jump_count = 0

	var direction = Input.get_axis("left", "right")
	velocity.x = direction * speed

	if direction != 0:
		flip_character = (direction == -1)
		sprite.flip_h = (direction == -1)
	
	load_animation()
	move_and_slide()

func load_animation():
	if is_on_floor() and velocity.x != 0:
		an.play("run")
	elif is_on_floor() and velocity.x == 0:
		an.play("idle")
	elif not is_on_floor():
		an.play("flip")
		
	if speed>700 and velocity.x !=0:
		#print("signal dashing animation") 
		an.play("dash")

func load_health_bar(hit:int, regen:int):
	$health_bar.value -= hit
	$health_bar.value += regen

func deal_with_damage(hit:int, regen:int):
	health -= hit
	health += regen
	load_health_bar(hit, regen)

func deal_with_money(coin: int):
	money += coin

func _on_player_hitbox_area_entered(area):
	if area.name == "coin":
		deal_with_money(1)
	elif area.name == "piks":
		deal_with_damage(10, 0)
	elif area.name == "monster_hitbox":
		deal_with_damage(15, 0)
	elif area.name == "medikit":
		deal_with_damage(0, 10)

func _on_dash_timeout():
	speed = 300
	can_dash = true

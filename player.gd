extends CharacterBody2D


const NORSPEED = 10
const OPOSPEED = 150
const JUMP_VELOCITY = -750
const MAX_X_VELOCITY = 900

var predash_x_velocity = 0

@onready var animation = $AnimatedSprite2D

var direction = "right"
var animation_type = "idle"

var has_dash = false
var recent_dash = false
var is_moving_LR = false


func _physics_process(delta):
	if is_on_floor():
		has_dash = true
		if recent_dash:
			velocity.x = predash_x_velocity
		recent_dash = false
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if is_on_floor() && !Input.is_action_pressed("Left") && !Input.is_action_pressed("Right") && !Input.is_action_pressed("Jump"):
		animation_type = "idle"
	
	if !Input.is_action_pressed("Left") && !Input.is_action_pressed("Right"):
		is_moving_LR = false
	else:
		is_moving_LR = true

	if Input.is_action_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		animation_type = "jump"
	
	if Input.is_action_pressed("Left"):
		direction = "Left"
		if velocity.x > 0:
			velocity.x -= OPOSPEED
		elif velocity.x > -MAX_X_VELOCITY:
			velocity.x -= NORSPEED
		else:
			velocity.x += 10
		
		if is_on_floor():
			animation_type = "walk"
		
	elif Input.is_action_pressed("Right"):
		direction = "right"
		if velocity.x < 0:
			velocity.x += OPOSPEED
		elif velocity.x < MAX_X_VELOCITY:
			velocity.x += NORSPEED
		else:
			velocity.x -= 10
		
		if is_on_floor():
			animation_type = "walk"
		
	else:
		velocity.x = move_toward(velocity.x, 0, OPOSPEED)
		
	if Input.is_action_just_pressed("Dash"):
		if direction == "right":
			if has_dash:
				predash_x_velocity = velocity.x
				if is_moving_LR:
					velocity.x = 1000
				else:
					velocity.x = 2000
				if !is_on_floor():
					has_dash = false
				velocity.y = 0
		else:
			if has_dash:
				predash_x_velocity = velocity.x
				if is_moving_LR:
					velocity.x = -1500
				else:
					velocity.x = -3000
				if !is_on_floor():
					has_dash = false
				if !is_on_floor():
					recent_dash = true
				velocity.y = 0
			
	move_and_slide()

func _process(_delta):
	if direction == "right":
		animation.flip_h = false
	else:
		animation.flip_h = true
		
	if animation_type == "idle":
		animation.play("Idle")
	elif animation_type == "walk":
		animation.play("Walk")
	else:
		animation.play("Jump")

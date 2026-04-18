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
	if globals.kcl_down || globals.osl_down: globals.l_down = true
	else: globals.l_down = false
	if globals.kcr_down || globals.osr_down: globals.r_down = true
	else: globals.r_down = false
	if globals.kcu_down || globals.osu_down: globals.u_down = true
	else: globals.u_down = false
	if globals.kcd_down || globals.osd_down: globals.d_down = true
	else: globals.d_down = false
	
	if is_on_floor():
		has_dash = true
		if recent_dash:
			velocity.x = predash_x_velocity
		recent_dash = false
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if is_on_floor() && !globals.l_down && !globals.r_down && !globals.u_down:
		animation_type = "idle"
	
	if !globals.l_down && !globals.r_down:
		is_moving_LR = false
	else:
		is_moving_LR = true

	if globals.u_down and is_on_floor():
		velocity.y = JUMP_VELOCITY
		animation_type = "jump"
	
	if globals.l_down:
		direction = "Left"
		if velocity.x > 0:
			velocity.x -= OPOSPEED
		elif velocity.x > -MAX_X_VELOCITY:
			velocity.x -= NORSPEED
		else:
			velocity.x += 10
		
		if is_on_floor():
			animation_type = "walk"
		
	elif globals.r_down:
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
		
	if globals.d_down:
		if direction == "right":
			if has_dash:
				animation_type = "dash"
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
				animation_type = "dash"
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
	if animation_type == "walk":
		animation.play("Walk")
	if animation_type == "jump":
		animation.play("Jump")
	if animation_type == "dash":
		animation.play("Dash")
	
	if globals.win:
		$WinParticles.show()


func _on_win_particle_detection_body_entered(body: Node2D) -> void:
	pass # Replace with function body.

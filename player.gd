extends CharacterBody2D


const NORSPEED = 25
const OPOSPEED = 150
const JUMP_VELOCITY = -750
const MAX_X_VELOCITY = 650

var predash_x_velocity = 0

@onready var animation = $AnimatedSprite2D

var direction = "right"
var animation_type = "idle"

var has_dash = false
var dashing = false
var recent_dash = false
var is_moving_LR = false


func _physics_process(delta):
	if globals.kcl_down: globals.l_down = true
	else: globals.l_down = false
	if globals.kcr_down: globals.r_down = true
	else: globals.r_down = false
	if globals.kcu_down: globals.u_down = true
	else: globals.u_down = false
	if globals.kcd_down: globals.d_down = true
	else: globals.d_down = false
	
	if is_on_floor():
		has_dash = true
		if recent_dash:
			velocity.x = 0
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
	
	if globals.l_down && !dashing:
		direction = "Left"
		if velocity.x > 0:
			velocity.x -= OPOSPEED
		elif velocity.x > -MAX_X_VELOCITY:
			velocity.x -= NORSPEED
		else:
			velocity.x += 100
		
		if is_on_floor():
			animation_type = "walk"
		
	elif globals.r_down && !dashing:
		direction = "right"
		if velocity.x < 0:
			velocity.x += OPOSPEED
		elif velocity.x < MAX_X_VELOCITY:
			velocity.x += NORSPEED
		else:
			velocity.x -= 100
		
		if is_on_floor():
			animation_type = "walk"
		
	else:
		velocity.x = move_toward(velocity.x, 0, OPOSPEED)
		
	if globals.d_down:
		if has_dash && $DashTimer.time_left == 0:
			if direction == "right":
				animation_type = "dash"
				predash_x_velocity = velocity.x
				velocity.x = 2500
				if !is_on_floor():
					has_dash = false
				velocity.y = 0
			else:
				animation_type = "dash"
				predash_x_velocity = velocity.x
				velocity.x = -2500
				if !is_on_floor():
					has_dash = false
				if !is_on_floor():
					recent_dash = true
				velocity.y = 0
			$DashTimer.start()
			
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
		
	if velocity.x > 1000 || velocity.x < -1000:
		dashing = true
	else:
		dashing = false
	
	if is_on_wall():
		animation_type = "jump"
		dashing = false
	
	if globals.win:
		$WinParticles.show()
	
	print($DashTimer.time_left)

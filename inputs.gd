extends CanvasLayer

func _process(_delta):
	if Input.is_action_pressed("Jump"): globals.kcu_down = true
	else: globals.kcu_down = false
	if Input.is_action_pressed("Left"): globals.kcl_down = true
	else: globals.kcl_down = false
	if Input.is_action_pressed("Right"): globals.kcr_down = true
	else: globals.kcr_down = false
	if Input.is_action_just_pressed("Dash"): globals.kcd_down = true
	else: globals.kcd_down = false

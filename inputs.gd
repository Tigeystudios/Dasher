extends CanvasLayer

func _process(_delta):
	if Input.is_action_pressed("Jump"): globals.kcu_down = true
	else: globals.kcu_down = false
	if Input.is_action_pressed("Left"): globals.kcl_down = true
	else: globals.kcl_down = false
	if Input.is_action_pressed("Right"): globals.kcr_down = true
	else: globals.kcr_down = false
	if Input.is_action_pressed("Dash"): globals.kcd_down = true
	else: globals.kcd_down = false

func _on_left_button_down():
	globals.osl_down = true
func _on_right_button_down():
	globals.osr_down = true
func _on_up_button_down():
	globals.osu_down = true
func _on_down_button_down():
	globals.osd_down = true
	
func _on_left_button_up():
	globals.osl_down = false
func _on_right_button_up():
	globals.osr_down = false
func _on_up_button_up():
	globals.osu_down = false
func _on_down_button_up():
	globals.osd_down = false

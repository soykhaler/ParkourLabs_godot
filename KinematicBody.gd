extends KinematicBody
export var speed = 14
export var fall_acceleration = 600
export var jump_speed = 150
export var dash_multiplier = 2.5
export var dash_time = 3
export var mouse_sensitivity = 0.1
export var joystick_sensitivity = 2
var target_velocity = Vector3.ZERO
var jumps = 0
var max_jumps = 2
var dash_timer = 0
var speed_multiplier = 1
var fov_target = 90
var fov_return_timer = 0
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$Camera.fov = 90
func _input(event):
	if event is InputEventMouseMotion:
		$Camera.rotation_degrees.x -= event.relative.y * mouse_sensitivity
		$Camera.rotation_degrees.x = clamp($Camera.rotation_degrees.x, -90, 90)
		rotation_degrees.y -= event.relative.x * mouse_sensitivity
func jump():
	if jumps < max_jumps:
		target_velocity.y = jump_speed
		jumps += 1
func _physics_process(delta):
	var direction = Vector3.ZERO
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.z += 1
	if Input.is_action_pressed("ui_up"):
		direction.z -= 1
	var deadzone = 0.3
	var joystick_right_y = Input.get_joy_axis(0, JOY_AXIS_3)
	if abs(joystick_right_y) < deadzone:
		joystick_right_y = 0
	$Camera.rotation_degrees.x -= joystick_right_y * joystick_sensitivity
	$Camera.rotation_degrees.x = clamp($Camera.rotation_degrees.x, -90, 90)
	var joystick_right_x = Input.get_joy_axis(0, JOY_AXIS_2)
	if abs(joystick_right_x) < deadzone:
		joystick_right_x = 0
	rotation_degrees.y -= joystick_right_x * joystick_sensitivity
	direction = direction.rotated(Vector3.UP, rotation.y)
	target_velocity.y -= fall_acceleration * delta
	if is_on_floor():
		jumps = 0
	if Input.is_action_just_pressed("ui_select"):
		jump()
	if Input.is_action_just_pressed("dash") and dash_timer <= 0:
		speed_multiplier = dash_multiplier
		dash_timer = dash_time
		fov_target = 120
		fov_return_timer = 3
	if dash_timer > 0:
		dash_timer -= delta
	else:
		speed_multiplier = 1
	target_velocity.x = direction.x * speed * speed_multiplier
	target_velocity.z = direction.z * speed * speed_multiplier
	target_velocity = move_and_slide(target_velocity, Vector3.UP)
	$Camera.fov = lerp($Camera.fov, fov_target, delta * 8)
	if fov_return_timer > 0:
		fov_return_timer -= delta
	else:
		fov_target = 90

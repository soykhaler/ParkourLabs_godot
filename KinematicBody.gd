extends KinematicBody
export var speed = 14
export var fall_acceleration = 600 
var target_velocity = Vector3.ZERO
export var mouse_sensitivity = 0.1
export var joystick_sensitivity = 2
export var jump_speed = 150 
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
func _input(event):
	if event is InputEventMouseMotion:
		$Camera.rotation_degrees.x -= event.relative.y * mouse_sensitivity
		$Camera.rotation_degrees.x = clamp($Camera.rotation_degrees.x, -90, 90)
		rotation_degrees.y -= event.relative.x * mouse_sensitivity
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
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	move_and_slide(target_velocity, Vector3.UP)
	if is_on_floor() and Input.is_action_just_pressed("ui_select"):
		target_velocity.y = jump_speed

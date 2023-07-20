extends KinematicBody

# Velocidad de movimiento del jugador en metros por segundo.
export var speed = 14
# Aceleración hacia abajo cuando está en el aire, en metros por segundo al cuadrado.
export var fall_acceleration = 600 # Aumentamos la aceleración hacia abajo para hacer que la caída sea más rápida.
var target_velocity = Vector3.ZERO

# Sensibilidad del ratón al mover la cámara.
export var mouse_sensitivity = 0.1
# Sensibilidad del joystick al mover la cámara.
export var joystick_sensitivity = 2

# Velocidad de salto del jugador en metros por segundo.
export var jump_speed = 150 # Aumentamos la velocidad de salto para hacer que el salto sea más rápido.

func _ready():
	# Ocultamos el cursor del ratón para que no interfiera con el movimiento de la cámara.
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		# Rotamos la cámara en el eje X (arriba y abajo) usando la posición del ratón en Y.
		$Camera.rotation_degrees.x -= event.relative.y * mouse_sensitivity
		$Camera.rotation_degrees.x = clamp($Camera.rotation_degrees.x, -90, 90)
		# Rotamos el cuerpo del jugador en el eje Y (izquierda y derecha) usando la posición del ratón en X.
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

	# Rotamos la cámara en el eje X (arriba y abajo) usando la posición del joystick derecho en Y.
	var joystick_right_y = Input.get_joy_axis(0, JOY_AXIS_3)
	$Camera.rotation_degrees.x -= joystick_right_y * joystick_sensitivity
	# Rotamos el cuerpo del jugador en el eje Y (izquierda y derecha) usando la posición del joystick derecho en X.
	var joystick_right_x = Input.get_joy_axis(0, JOY_AXIS_2)
	rotation_degrees.y -= joystick_right_x * joystick_sensitivity

	# Transformamos el vector de dirección de entrada en el espacio global.
	direction = direction.rotated(Vector3.UP, rotation.y)
	# Aplicamos la gravedad al jugador.
	target_velocity.y -= fall_acceleration * delta
	# Movemos al jugador en la dirección de entrada.
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	move_and_slide(target_velocity, Vector3.UP)

	if is_on_floor() and Input.is_action_just_pressed("ui_select"):
		# Si el jugador está en el suelo y presiona la tecla de salto, aplicamos una fuerza hacia arriba.
		target_velocity.y = jump_speed

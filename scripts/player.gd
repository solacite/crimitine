extends CharacterBody3D

@export var speed := 4.0 # mvmt speed
@export var mouse_sens := 0.002 # sens
@export var jump_force := 4.0 # jump strength

var head
var camera  # ref to cam node
var rotation_x := 0.0  # stores up/down look angle

func _ready():
	head = $Head
	camera = $Head/Camera3D  # get cam
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  # lock + hide cursor in game

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sens)
		rotation_x = clamp(rotation_x - event.relative.y * mouse_sens, -1.5, 1.5)
		head.rotation.x = rotation_x

func _physics_process(delta):
	var input_dir = Vector3.ZERO  # direction to move

	var forward = -transform.basis.z  # forward vector of player
	var right = transform.basis.x  # right vector of player

	# check input keys + add direction
	if Input.is_action_pressed("move_fwd"):
		input_dir += forward
	if Input.is_action_pressed("move_bkwd"):
		input_dir -= forward
	if Input.is_action_pressed("move_right"):
		input_dir += right
	if Input.is_action_pressed("move_left"):
		input_dir -= right

	input_dir = input_dir.normalized()  # normalize so diagonal isn’t faster
	velocity.x = input_dir.x * speed  # apply mvmt on x axis
	velocity.z = input_dir.z * speed  # apply mvmt on z axis

	velocity.y -= ProjectSettings.get_setting("physics/3d/default_gravity") * delta  
	# gravitee (tea!)
	
	# jump! jump! jump! slide to the right, slide to the left, clap your hands something something
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force

	move_and_slide()  # move player!

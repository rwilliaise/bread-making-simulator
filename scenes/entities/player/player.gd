extends CharacterBody3D
class_name Player

@onready var HEAD := $Head

@export var MOUSE_SENSITIVITY = 0.2
@export var JUMP_POWER = 4
@export var WALK_SPEED = 8
@export var ACCELERATE = 10
@export var DECELERATE = 15
@export var GRAVITY = Vector3(0, -9.8, 0)

var direction := Vector2()

func _ready():
	GlobalVars.current_player = self
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	direction = Input.get_vector("strafe_left", "strafe_right", "move_backward", "move_forward")

	var head_global_transform = HEAD.global_transform.basis
	var move_direction := Vector3()
	move_direction += -head_global_transform.z * direction.y
	move_direction += head_global_transform.x * direction.x
	move_direction.y = 0
	move_direction = move_direction.normalized()

	velocity += delta * GRAVITY

	if is_on_floor():
		if Input.is_action_just_pressed("move_jump"):
			velocity.y = JUMP_POWER
	
	var vertical_velocity = velocity.y
	var horizontal_velocity = velocity
	horizontal_velocity.y = 0

	var target = move_direction * WALK_SPEED
	var acceleration = ACCELERATE

	if move_direction.dot(horizontal_velocity) <= 0: # attempting to move opposite to horizontal velocity
		acceleration = DECELERATE

	velocity = velocity.move_toward(target, acceleration * delta);
	velocity.y = vertical_velocity
	move_and_slide()
	
func _input(event: InputEvent):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		HEAD.rotate_x(deg_to_rad(-event.relative.y * MOUSE_SENSITIVITY))
		rotate_y(deg_to_rad(-event.relative.x * MOUSE_SENSITIVITY))

		var rot = HEAD.rotation_degrees
		rot.x = clamp(rot.x, -89, 89)

		HEAD.rotation_degrees = rot
	if event is InputEventMouseButton:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

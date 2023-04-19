extends ProgressBar
class_name SmoothProgressBar

@export var speed = 1
@export var smooth_value = 0 : 
	get:
		return smooth_value
	set(new_value):
		smooth_value = new_value
		set_process(true)

func reset():
	smooth_value = 0
	value = 0
	set_process(false)

func _process(delta):
	if smooth_value == value:
		set_process(false)
		return

	value = move_toward(value, smooth_value, delta * speed)

extends Node3D

@export var bread_scene: PackedScene
@onready var BREAD = $Bread

@onready var PROGRESS_BAR = $CanvasLayer/ProgressBar
@onready var PRO_TIP = $CanvasLayer/ProgressBar/Protip
@onready var PLAY = $CanvasLayer/MenuUI/MarginContainer/VBoxContainer/Play

var value = 0

var _protips = [
	"Heaven almighty, you will not survive. Good luck",
	"Bread making simulators one and two have still not been found",
	"NOW!!",
	"bake hte bread jesse"
]

func set_progress(amount):
	if amount == -1:
		value = null
		PROGRESS_BAR.visible = false
		return

	if value == null:
		PROGRESS_BAR.visible = true
		PRO_TIP.text = "Protip: " + _protips.pick_random()
		set_process(true)
	
	value = amount

func _on_timeout():
	var bread = bread_scene.instantiate()
	BREAD.add_child(bread)
	bread.global_position = BREAD.global_position + Vector3(randf_range(-1, 1), 0, randf_range(-1, 1))
	bread.apply_central_impulse(Vector3(0, -20, 0))
	print("BREAD: spawned")

func _ready():
	GlobalVars.current_hud = self

func _process(delta):
	if value == null:
		set_process(false)
		return

	PROGRESS_BAR.value = move_toward(PROGRESS_BAR.value, value, delta * 0.05)

func _play():
	PLAY.disabled = true
	GlobalVars.load_scene("res://scenes/mortal_plane.tscn")


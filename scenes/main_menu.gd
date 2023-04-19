extends Node3D

@export var bread_scene: PackedScene

@onready var BREAD = $Bread
@onready var PLAY = $CanvasLayer/MenuUI/MarginContainer/VBoxContainer/Play

func _on_timeout():
	var bread = bread_scene.instantiate()
	BREAD.add_child(bread)
	bread.global_position = BREAD.global_position + Vector3(randf_range(-1, 1), 0, randf_range(-1, 1))
	bread.apply_central_impulse(Vector3(0, -20, 0))

func _play():
	PLAY.disabled = true
	Global.load_scene("res://scenes/mortal_plane.tscn")


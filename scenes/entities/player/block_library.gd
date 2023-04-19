extends Node3D
class_name ComponentLibrary

@export var HOVER_MATERIAL: Material

@export var STRUCTURAL: PackedScene

@onready var CAST := $Cast
@onready var CAMERA := $Camera
@onready var VIEWPORT = $CanvasLayer/SubViewportContainer/SubViewport
@onready var VIEWPORT_CONTAINER = $CanvasLayer/SubViewportContainer
@onready var VIEWPORT_CAMERA := $CanvasLayer/SubViewportContainer/SubViewport/ViewportCamera

@onready var selected = STRUCTURAL
@onready var selected_preview = selected.instantiate()

var _hovered: Array[GeometryInstance3D] = []

func _clear_hovered():
	for hover in _hovered:
		if !is_instance_valid(hover):
			continue
		hover.material_overlay = null
	_hovered.clear()

func _try_hover():
	_clear_hovered()
	if CAST.is_colliding() && is_instance_valid(CAST.get_collider()) && CAST.get_collider().is_in_group("component"):
		for child in CAST.get_collider().get_children():
			if child is GeometryInstance3D:
				_hovered.push_back(child)
				child.material_overlay = HOVER_MATERIAL

func _ready():
	VIEWPORT.add_child(selected_preview)

func _input(event):
	if event is InputEventMouseMotion && Input.is_action_pressed("component_break"):
		_try_hover()
	if Input.is_action_just_pressed("component_place"):
		if CAST.is_colliding():
			if Input.is_action_pressed("component_break"):
				if CAST.get_collider().is_in_group("component"):
					CAST.get_collider().queue_free()
			else:
				var component = selected.instantiate()
				get_tree().current_scene.add_child(component)
				component.global_position = (CAST.get_collision_point() + CAST.get_collision_normal() * 0.5).round()

func _process(_delta):
	VIEWPORT_CAMERA.global_transform = CAMERA.global_transform
	if Input.is_action_just_released("component_break"):
		_clear_hovered()
	if CAST.is_colliding():
		if Input.is_action_pressed("component_break"):
			_try_hover()
			VIEWPORT_CONTAINER.visible = false
		else:
			VIEWPORT_CONTAINER.visible = true
			selected_preview.global_position = (CAST.get_collision_point() + CAST.get_collision_normal() * 0.5).round()
	else:
		VIEWPORT_CONTAINER.visible = false
		


extends StaticBody3D

@export var BREAD: PackedScene

@export var active: bool

func _on_timeout():
	if active:
		var bread = BREAD.instantiate()
		var tree = get_tree()
		tree.current_scene.add_child(bread)
		bread.global_position = global_position

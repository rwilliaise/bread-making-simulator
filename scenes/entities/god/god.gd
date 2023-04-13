extends Sprite3D

var MOUTH_OPEN = "res://textures/god/god_speak_open.png"

func _process(_delta):
	if GlobalVars.current_player != null:
		look_at(GlobalVars.current_player.global_position)



extends Label

@onready var ANIMATION_PLAYER: AnimationPlayer = $AnimationPlayer

func _ready():
	label_settings.font_color = Color(255, 255, 255, 0)
	label_settings.shadow_color = Color(0, 0, 0, 0)

func announce(text: String):
	ANIMATION_PLAYER.play("")


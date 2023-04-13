extends Control

@onready var CONTROL_LABEL = $ControlLabel
@onready var SPEAK = $Speak

func _ready():
	GlobalVars.current_hud = self

func announce(text: String):
	SPEAK.announce(text)

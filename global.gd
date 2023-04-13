extends Node

## Global pointer to the current player found in the scene.
var current_player: Player

## Global pointer to current save the game is loaded into.
var current_save: SaveData

## Global pointer to current HUD open in-game.
var current_hud: Control

func announce(text: String):
	if current_hud.has_method("announce"):
		current_hud.announce(text)


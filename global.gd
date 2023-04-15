extends Node

## Global pointer to the current player found in the scene.
var current_player: Player

## Global pointer to current save the game is loaded into.
var current_save: SaveData

## Global pointer to current HUD open in-game.
var current_hud 

## Global pointer to currently loaded scene
var current_scene: Node


var _loading

## Show a progress bar over the current HUD. Should be used exclusively for loading.
func set_progress(amount):
	if current_hud != null && current_hud.has_method("set_progress"):
		current_hud.set_progress(amount)

## Sets the scene to a new scene.
func set_new_scene(new_scene: Node):
	current_scene.queue_free()
	current_scene = new_scene

	get_tree().get_root().add_child(new_scene)

## Loads a new scene and shows a progress bar on the current HUD.
func load_scene(new_path: String):
	if _loading != null:
		push_warning("LOAD: Attempted to load new scene during scene load")
		return

	_loading = new_path
	
	set_progress(0)

	ResourceLoader.load_threaded_request(new_path, "", true)

	set_process(true)

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)

func _process(_delta):
	if _loading == null:
		set_process(false)
		return

	var progress = []
	var result = ResourceLoader.load_threaded_get_status(_loading, progress)

	match result:
		ResourceLoader.THREAD_LOAD_LOADED:
			var scene = ResourceLoader.load_threaded_get(_loading)

			_loading = null

			set_progress(-1)
			set_new_scene(scene.instantiate())
			set_process(false)
			return
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			print("LOAD: progress: " + str(progress[0]))
			set_progress(progress[0])
		_:
			push_warning("LOAD: Got result value instead: " + result)
			set_process(false)
			return



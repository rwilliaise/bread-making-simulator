extends Node

## Global pointer to the current player found in the scene.
var current_player: Player

# # Global pointer to current save the game is loaded into.
# var current_save: SaveData

## Global pointer to current HUD open in-game.
var current_hud 


@onready var PROGRESS_BAR = $ProgressBar
@onready var PROTIP = $ProgressBar/Protip

var _loading
var _protips = [
	"Heaven almighty, you will not survive. Good luck",
	"Bread making simulators one and two have still not been found",
	"NOW!!",
	"bake hte bread jesse"
]

## Show a progress bar over the current HUD. Should be used exclusively for loading.
func set_progress(amount):
	if amount == null:
		PROGRESS_BAR.visible = false
		PROGRESS_BAR.reset()
		return

	if PROGRESS_BAR.visible == false:
		PROGRESS_BAR.visible = true
		PROTIP.text = "PROTIP: " + _protips.pick_random()

	PROGRESS_BAR.smooth_value = amount

## Sets the scene to a new scene.
func set_new_scene(new_scene: Node):
	var tree = get_tree()
	if tree.current_scene != null:
		tree.current_scene.queue_free()

	tree.get_root().add_child(new_scene)
	tree.current_scene = new_scene

## Loads a new scene and shows a progress bar on the current HUD.
func load_scene(path: String):
	if _loading != null:
		push_warning("LOAD: Attempted to load new scene during scene load")
		return

	_loading = path

	set_progress(0)

	ResourceLoader.load_threaded_request(path)
	set_process(true)

func _process(_delta):
	if _loading == null:
		set_process(false)
		return

	var progress = []
	var result = ResourceLoader.load_threaded_get_status(_loading, progress)

	match result:
		ResourceLoader.THREAD_LOAD_LOADED:
			var load_into = func():
				var scene = ResourceLoader.load_threaded_get(_loading)

				_loading = null

				set_progress(null)
				set_new_scene(scene.instantiate())
				
			get_tree().create_timer(1).timeout.connect(load_into)
			set_progress(1)
			set_process(false)
			return
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			print("LOAD: progress: " + str(progress[0]))
			set_progress(progress[0])
		ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
			return
		_:
			push_warning("LOAD: Got result value instead: " + str(result))
			set_progress(-1)
			set_process(false)
			return



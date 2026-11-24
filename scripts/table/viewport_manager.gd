extends Control

@onready var sub_viewport: SubViewport = $SubViewportContainer/SubViewport
var minigame: Node = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sub_viewport.canvas_item_default_texture_filter = Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_NEAREST

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _init_minigame(path: String) -> void:
	var minigame_scene: Resource
	
	if minigame:
		minigame.queue_free()

	print("Minigame set from path: ", path)
	if path == "":
		push_warning("Minigame not Found!")
		return
	minigame_scene = load(path)
	if not minigame_scene:
		push_error("Couldn't load Minigame from Path: %s!" %path)
		return
	minigame = minigame_scene.instantiate()
	minigame.connect("minigame_finished", Callable(self, "_on_minigame_finished"))
	sub_viewport.add_child(minigame)
pass

# TEST: for debug currently
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("close_minigame"):
		_close_minigame()
pass

# NOTE:
# 	Logic for what happens when the game is either won or lost (e.g.: Manipulation of Ghost meters)
# 	Though Logic should be in table script not in viewport_manager
# 	Then close the minigame
func _on_minigame_finished(success: bool) -> void:
	if success == true:
		print("success!")
	else:
		print("failure!")
	_close_minigame()
pass

# clear minigame and sets itself hidden
func _close_minigame() -> void:
	if minigame:
		minigame.queue_free()
		minigame = null
	self.visible = false
pass

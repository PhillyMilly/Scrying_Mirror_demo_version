extends Control

# NOTE: Add minigames into this Dicionary
@export var minigame_entries: Array[MinigameEntry]

@onready var game_manager: Node = %GameManager
@onready var job_manager: Node = %JobManager
@onready var information_manager: Node = %InformationManager
@onready var subviewport_container: SubViewportContainer = $MinigameViewportContainer
@onready var minigames:	Dictionary
# Signals

signal minigame_result(success: bool, id: String)

# Globals
@export var MINIGAME_WIN_SIZE: Vector2 = Vector2(320, 240)
@export var MINIGAME_WIN_POS: Vector2 = Vector2(-160, -144)
var minigame_window: SubViewport = null
var current_minigame: Node = null

var _minigame_id: String = ""
var minigame_id: String:
	get: return _minigame_id
	set(value):
		_minigame_id = value
		_init_viewport()
		if value != "pendulum" or value != "crystalorb" or value != "oujia" or value != "spiritbox":
			_load_minigame(value, "")

func _ready() -> void:
	_populate_minigames_dictionary()
	job_manager.connect("start_minigame", Callable(self, "_set_minigame_id"))
	job_manager.connect("close_minigame", Callable(self, "_close_minigame"))
	information_manager.connect("start_information_minigame", Callable(self, "_load_information_minigame"))

func _populate_minigames_dictionary():
	minigames.clear()
	for entry in minigame_entries:
		if entry and entry.key != "" and entry.scene:
			minigames[entry.key] = entry.scene.resource_path
		elif !entry:
			print("Warning: Found a null entry in minigame_entries array.")
		elif entry.key == "":
			print("Warning: Minigame entry has an empty key.")
		elif !entry.scene:
			print("Warning: Minigame entry with key '%s' is missing a scene." % entry.key)

func _set_minigame_id(id: String) -> void:
	minigame_id = id

func _init_viewport() -> void:

	if minigame_window == null:
		minigame_window = SubViewport.new()
		minigame_window.name = "MinigameSubViewport"
		minigame_window.size = MINIGAME_WIN_SIZE
		minigame_window.canvas_item_default_texture_filter = Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_NEAREST

		subviewport_container.add_child(minigame_window)

func _load_minigame(id: String, to_solve: String) -> void:
	var minigame_scene: PackedScene
	
	if current_minigame:
		current_minigame.queue_free()
		current_minigame = null

	if !minigames.has(id):
		push_error("Couldn't match minigame_id %s with an exisiting minigame!" %minigame_id)

	minigame_scene = load(minigames[id])
	current_minigame = minigame_scene.instantiate()
	if to_solve != "":
		current_minigame.answer = to_solve
	minigame_window.add_child(current_minigame)

	if current_minigame.has_signal("minigame_finished"):
		current_minigame.connect("minigame_finished", Callable(self, "_on_minigame_finished"))

func _load_information_minigame(id: String, to_solve: String) -> void:
	_load_minigame(id, to_solve)

func _on_minigame_finished(success: bool) -> void:
	minigame_result.emit(success, minigame_id)
	
func _close_minigame() -> void:
		if current_minigame:
			current_minigame.queue_free()
			current_minigame = null
		if minigame_window:
			minigame_window.queue_free()
			minigame_window = null

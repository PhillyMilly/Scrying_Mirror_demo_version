extends Node2D

const MINIGAME_POS: Vector2 = Vector2(-512, -510)
var disable_tools: bool = false

@onready var minigame_window: Control = $MinigameWindow

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var ingame_ui_node: Control = $InGameUI
	
	minigame_window.visible = false
	ingame_ui_node.connect("minigame_selected", Callable(self, "_on_minigame_selected"))
pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_minigame_selected(path: String) -> void:
	
	# WARNING: change this if statement later
	if minigame_window.visible == false:
		disable_tools = false
	if disable_tools == true:
		return
	print("Minigame selected with path: ", path)
	
	minigame_window._init_minigame(path)
	minigame_window.visible = true
	print("disabling tools...")
	disable_tools = true
pass

# TODO: [x] Disable minigame selection after one is chosen / focus on the viewport
#		[x] close minigame when won
#		[x] spawn the viewport in the right position
#		[x] fix blurry rendering of minigames
#		[ ] research more about viewports

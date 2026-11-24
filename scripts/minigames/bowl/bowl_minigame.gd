extends Node2D

signal minigame_finished(success: bool)
@onready var player_node: CharacterBody2D = $Stick
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_node.game_finished == true:
		finish()

func finish():
	set_process(false)
	minigame_finished.emit(true)

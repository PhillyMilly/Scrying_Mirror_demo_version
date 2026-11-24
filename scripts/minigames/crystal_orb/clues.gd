extends Node2D

var clue_count:	int
var clue_num:	int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	clue_count = 0
	clue_num = get_child_count(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

extends Area2D

@onready var clues: Node2D = $".."
@onready var crystal_orb: Node2D = $"../../../.."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_entered(area: Area2D) -> void:
	print("CLUE FOUND!")
	get_node("CollisionShape2D").queue_free()
	clues.clue_count += 1
	if clues.clue_count == clues.clue_num:
		print("GAME FINISHED!")
		await get_tree().create_timer(3.5).timeout
		crystal_orb.minigame_finished.emit(true)

extends Area2D

@export var letter: String
@onready var ouija_board: Node2D = $"../../"
@onready var ouija_arrow: CharacterBody2D = $"../../OuijaArrow"

var  is_double: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	monitoring = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	ouija_board.str += letter
	if is_double:
		ouija_board.str += letter
	ouija_arrow.get_node("Collision").disabled = true

extends Area2D

@onready var pendulum_minigame: Node2D = $"../.."

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body.name == "pendulum":
		pendulum_minigame.register_hit("middle")

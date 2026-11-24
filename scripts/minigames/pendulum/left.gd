extends Area2D

@onready var my_sprite: Sprite2D = $left_sprite
@onready var right_sprite: Sprite2D = $"../right/right_sprite"
@onready var pendulum_minigame: Node2D = $"../.."

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body.name == "pendulum":
		pendulum_minigame.register_hit("left")

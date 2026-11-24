extends Area2D

@onready var sprite_2d: Sprite2D = $Sprite2D;
@onready var hover: Texture2D = preload("res://assets/sprites/ui/hover.png");
@onready var orb: Item = $"../../Orb";
@onready var pendulum: Item = $"../../Pendulum"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass;


func _on_mouse_entered() -> void:
	sprite_2d.texture = hover;
	if (orb.is_grabbing):
		orb.anchor_position = global_position;
	if (pendulum.is_grabbing):
		pendulum.anchor_position = global_position;


func _on_mouse_exited() -> void:
	sprite_2d.texture = null;

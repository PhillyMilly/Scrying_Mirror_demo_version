extends RigidBody2D

@export var min_speed = 500
@export var max_speed = 1000
@export var damage_per_second: float = 1.0

@onready var healthbar = $HealthBar

signal sig_i_died()

var is_mouse_inside: bool = false
var health: float = 6

func _ready() -> void:
	healthbar._init_health(health)

func _process(delta: float) -> void:
	if is_mouse_inside == true:
		_set_health(health - damage_per_second * delta)

func _set_health(value: float) -> void:
	health = value
	healthbar.health = health
	if health <= 0:
		_die()

func _die() -> void:
	sig_i_died.emit()
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	sig_i_died.emit()
	queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	is_mouse_inside = true


func _on_area_2d_area_exited(area: Area2D) -> void:
	is_mouse_inside = false

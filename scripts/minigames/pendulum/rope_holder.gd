extends CharacterBody2D

@export var move_speed := 30.0
var is_hovering:	bool
var is_grabbing:	bool

func _process(delta):
	var target = get_global_mouse_position()
	if Input.is_action_pressed("mouse_left") && is_hovering:
		is_grabbing = true
		position = position.move_toward(target, move_speed * delta)
		position.y = -93
	elif Input.is_action_just_released("mouse_left"):
		is_grabbing = false
		


func _on_mouse_body_entered(body: Node2D) -> void:
	is_hovering = true


func _on_mouse_body_exited(body: Node2D) -> void:
	if !is_grabbing:
		is_hovering = false

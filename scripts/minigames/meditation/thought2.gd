extends RigidBody2D

var is_mouse_inside: bool = false
var is_dead: bool = false

var prev_mouse_pos: Vector2 = Vector2.ZERO

func _ready() -> void:
	prev_mouse_pos = get_global_mouse_position()

func _process(delta: float) -> void:
	var current_mouse_pos: Vector2
	var direction: Vector2
	
	current_mouse_pos = get_global_mouse_position()
	direction = current_mouse_pos - prev_mouse_pos
	direction = direction.normalized()
	if is_mouse_inside == true && Input.is_action_pressed("mouse_left"):
		position.y = get_global_mouse_position().y + 30
		position.x = get_global_mouse_position().x
	if is_mouse_inside == true && Input.is_action_just_released("mouse_left"):
		_shoot_thought(direction, delta)
	
func _shoot_thought(direction: Vector2, delta: float) -> void:
	print("hello")
	var speed = 500
	position += direction.normalized() * speed * delta
	pass
	

func _die() -> void:
	if is_dead == true:
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	is_dead = true
	_die()

func _on_area_2d_mouse_entered() -> void:
	is_mouse_inside = true

func _on_area_2d_mouse_exited() -> void:
	is_mouse_inside = false

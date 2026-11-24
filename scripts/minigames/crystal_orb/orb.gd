extends AnimatedSprite2D

@onready var arrows: AnimatedSprite2D = $"../Arrows"
@onready var hand: AnimatedSprite2D = $"../Hand"
@onready var vision: CharacterBody2D = $"../VisionMask/Vision"

var is_hovering: bool
var is_grabbed: bool
var last_mouse_position: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO

const SPEED: float = 600.0
const FRICTION: float = 3.0  # higher = faster stopping
const ACCEL: float = 10.0    # higher = more responsive

func _process(delta: float) -> void:
	if Input.is_action_pressed("mouse_left") && is_hovering:
		if !is_grabbed:
			is_grabbed = true
			last_mouse_position = get_global_mouse_position()

		var current_mouse_position = get_global_mouse_position()
		var mouse_delta = current_mouse_position - last_mouse_position

		if mouse_delta.length() > 0.1:
			var desired_velocity = mouse_delta.normalized() * SPEED
			velocity = velocity.lerp(desired_velocity, ACCEL * delta)
		else:
			# apply friction if mouse is held but not moving
			velocity = velocity.lerp(Vector2.ZERO, FRICTION * delta)

		last_mouse_position = current_mouse_position
	else:
		is_grabbed = false
		# apply friction when not grabbing
		velocity = velocity.lerp(Vector2.ZERO, FRICTION * delta)

	# apply movement
	vision.global_position += velocity * delta
	vision.move_and_slide()

func _on_mouse_body_entered(body: Node2D) -> void:
	is_hovering = true

func _on_mouse_body_exited(body: Node2D) -> void:
	is_hovering = false

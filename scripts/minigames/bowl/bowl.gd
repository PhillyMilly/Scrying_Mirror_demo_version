extends StaticBody2D

var original_position := Vector2.ZERO
var shaking := false
var shake_intensity := 2.0

func _ready() -> void:
	original_position = position

func _process(_delta: float) -> void:
	if shaking:
		var shake_offset = Vector2(randf_range(-shake_intensity, shake_intensity),
								   randf_range(-shake_intensity, shake_intensity))
		position = original_position + shake_offset
	else:
		position = original_position

func start_shake(duration: float, intensity: float = 2.0) -> void:
	shake_intensity = intensity
	shaking = true
	await get_tree().create_timer(duration).timeout
	shaking = false

  

extends ProgressBar

var _health: float = 0.0

var health: float:
	set(value):
		_health = clamp(value, 0, max_value)
		self.value = _health
		if _health <= 0:
			queue_free()
	get:
		return _health

func _init_health(_health: float) -> void:
	health = _health
	max_value = health
	value = health

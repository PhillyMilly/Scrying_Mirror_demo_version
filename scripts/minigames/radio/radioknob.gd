extends Area2D
@onready var radio_knob: Sprite2D = $RadioKnob

@export var min_freq := 88.0
@export var max_freq := 108.0
@export var step := 0.1 # Frequenzänderung pro Mausradklick

signal frequency_changed(freq: float)

var current_freq = 88.0

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			current_freq = clamp(current_freq + step, min_freq, max_freq)
			update_knob()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			current_freq = clamp(current_freq - step, min_freq, max_freq)
			update_knob()

func update_knob():
	var sprite = radio_knob # adjust the node path if needed
	var x_min = -121.0
	var x_max = 70.0
	
	# Map current_freq to x position
	var t = (current_freq - min_freq) / (max_freq - min_freq) # normalized value between 0 and 1
	var new_x = lerp(x_min, x_max, t)
	
	sprite.position.x = new_x
	sprite.position.y = -34 # constant y position

	emit_signal("frequency_changed", current_freq)

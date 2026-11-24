extends Node2D

@onready var true_signal: Area2D = $TrueSignal
var meow: AudioStream = preload("res://assets/sounds/minigames/spiritbox/mauw.wav")

var positions: Array[Vector2]
var selected_range: int
var selected_position: int
var answer
var x: float
var y: float

signal minigame_finished(success: bool)

func _ready() -> void:
	randomize()
	generate_positions()
	print(answer)
	if answer == "Meow":
		set_signal(true_signal, meow)

func set_signal(selected_signal: Area2D, selected_song: AudioStream):
	generate_position(selected_signal)
	selected_signal.song = selected_song
	selected_signal.is_true_signal = true

func generate_positions() -> void:
	selected_range = randi_range(0, 2)
	if selected_range == 2:
		x = randf_range(-145, -50)
		y = randf_range(-110, -40)
	elif selected_range == 1:
		x = randf_range(145, 50)
		y = randf_range(-110, -40)
	else:
		x = randf_range(-145, 145)
		y = randf_range(110, 40)
	
	positions.append(Vector2(x, y))

func generate_position(selected_signal: Area2D):
	selected_signal.position = positions[0]
	positions.remove_at(selected_position)

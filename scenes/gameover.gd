extends Node2D

@onready var retry: Button = $retry
@onready var quit: Button = $quit
@onready var true_song_00: AudioStreamPlayer = $TrueSong00
@onready var gameover: Sprite2D = $Gameover
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var background: Sprite2D = $Sprite2D


# ✨ Schwebe-Variablen
var float_amplitude := 1.0
var float_speed := 0.6
var float_time := 0.0
var base_position: Vector2

func _ready() -> void:
	true_song_00.play()
	animated_sprite_2d.play()
	base_position = gameover.position # Ausgangsposition speichern

func _process(delta: float) -> void:
	# ✨ Schwebeeffekt anwenden
	float_time += delta
	gameover.position.y = base_position.y + sin(float_time * PI * 2 * float_speed) * float_amplitude
	background.position.y = base_position.y + sin(float_time * PI * 2 * float_speed + 2) * float_amplitude

func _on_retry_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/titlescreen.tscn")
	
func _on_quit_pressed() -> void:
	get_tree().quit()

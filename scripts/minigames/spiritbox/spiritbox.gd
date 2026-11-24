extends CharacterBody2D

@onready var static_noise = $AudioStreamPlayerStatic
@onready var true_song = $AudioStreamPlayerTrue
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var true_signal: Node2D = $"../TrueSignal" # <-- WICHTIG: Referenz zum Zielsignal

var in_area: bool = false
var song_found: bool = false

signal minigame_finished(success: bool)

var is_hovering: bool = false
var is_grabbing: bool = false

# Steuerung der FPS
var max_fps := 15.0
var min_fps := 2.0
var max_distance := 400.0 # Je nach Größe deiner Szene anpassen

func _process(delta):
	if Input.is_action_pressed("mouse_left") and is_hovering:
		is_grabbing = true
		global_position = get_global_mouse_position()

	update_animation_speed()

func update_animation_speed():
	if not true_signal or not sprite:
		return

	var distance = global_position.distance_to(true_signal.global_position)
	var t = clamp(1.0 - distance / max_distance, 0.0, 1.0) # 1.0 = nah, 0.0 = weit weg
	var new_fps = lerp(min_fps, max_fps, t)
	sprite.speed_scale = new_fps

func _on_mouse_body_entered(body: Node2D) -> void:
	is_hovering = true

func _on_mouse_body_exited(body: Node2D) -> void:
	if not is_grabbing:
		is_hovering = false

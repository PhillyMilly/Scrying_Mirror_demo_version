extends Node2D

@onready var title_music: AudioStreamPlayer = $ChillBill
@onready var chill_bill_no_contact: AudioStreamPlayer = $ChillBillNoContact
@onready var animated_sprite_2d: AnimatedSprite2D = $start
@onready var button: Button = $Button
@onready var forground: Sprite2D = $Forground
@onready var background: Sprite2D = $Background
@onready var end: AnimatedSprite2D = $end

var crossfade_time := 1.0
var fading := false
var fade_timer := 0.0
var song_position: float
var is_button_pressed: bool = false

# ✨ Schwebe-Variablen
var float_amplitude := 1.0 # Höhe der Bewegung
var float_speed := 0.6     # Geschwindigkeit (Zyklen/Sekunde)
var float_time := 0.0
var base_position: Vector2

func _ready() -> void:
	is_button_pressed = false
	base_position = forground.position # Startposition speichern
	button.pressed.connect(_on_button_pressed)

func _process(delta: float) -> void:
	# ✨ Schweben lassen
	float_time += delta
	forground.position.y = base_position.y + sin(float_time * PI * 2 * float_speed) * float_amplitude
	background.position.y = base_position.y + sin(float_time * PI * 2 * float_speed + 2) * float_amplitude

	# 🎵 Crossfade starten
	if not fading and is_button_pressed:
		fading = true
		fade_timer = 0.0

	if fading:
		fade_timer += delta
		var t: float = clamp(fade_timer / crossfade_time, 0.0, 1.0)

		if t <= 0.5:
			var fade_in := t * 2.0
			chill_bill_no_contact.volume_db = lerp(-80, 0, fade_in)
			title_music.volume_db = 0.0
		else:
			var fade_out := (t - 0.5) * 2.0
			chill_bill_no_contact.volume_db = 0.0
			title_music.volume_db = lerp(0, -80, fade_out)

		if t >= 1.0:
			fading = false
			Audio.song_position = chill_bill_no_contact.get_playback_position() + AudioServer.get_time_since_last_mix()
			end.play()
			await get_tree().create_timer(2).timeout
			get_tree().change_scene_to_file("res://scenes/table/table.tscn")

func _on_button_pressed() -> void:
	is_button_pressed = true

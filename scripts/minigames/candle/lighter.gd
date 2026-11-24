extends CharacterBody2D

@onready var fire_sprite = $Fire
@onready var collision_shape = $CollisionShape2D
@onready var lighter_click: AudioStreamPlayer = $LighterClick
@onready var candle_0: Candle = $"../candle0"
@onready var candle_1: Candle = $"../candle1"
@onready var candle_2: Candle = $"../candle2"
@onready var animated: AnimatedSprite2D = $Animated

var heat_timer: float = 0.0
var overheat_threshold: float = 4.0  # Sekunden bis Überhitzung
var is_overheated: bool = false
var cooldown_timer: float = 0.0
var cooldown_duration: float = 2.0

var original_position: Vector2

func _ready():
	collision_shape.disabled = true
	fire_sprite.visible = false
	original_position = position

func _process(delta):
	position = get_global_mouse_position()

	if is_overheated:
		#candle_0.get_node("Candle").stop()
		#candle_1.get_node("Candle").stop()
		#candle_2.get_node("Candle").stop()
		cooldown_timer += delta
		# Leichtes Zittern
		position += Vector2(randf_range(-1.0, 1.0), randf_range(-2.0, 2.0))
		fire_sprite.visible = false
		collision_shape.disabled = true

		if cooldown_timer >= cooldown_duration:
			is_overheated = false
			cooldown_timer = 0.0
			heat_timer = 0.0
			position = original_position  # Reset Shake
	else:
		if Input.is_action_just_pressed("mouse_left"):
			lighter_click.play()
			animated.play("light")
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			fire_sprite.visible = true
			fire_sprite.play("fire")
			collision_shape.disabled = false
			heat_timer += delta

			if heat_timer >= overheat_threshold:
				is_overheated = true
				print(" Lighter überhitzt!")
		else:
			fire_sprite.visible = false
			collision_shape.disabled = true
			heat_timer = max(0.0, heat_timer - delta * 2)  # Schnelles Abkühlen

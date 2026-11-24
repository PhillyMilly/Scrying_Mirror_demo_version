extends Area2D
class_name Candle

@onready var fire_sprite: AnimatedSprite2D = $Fire

var required_burn_time: float = 1.5
var burn_timer: float = 0.0
var is_burning: bool = false
var extinguish_delay: float = 3.9
var extinguish_timer: float = 0.0
var should_extinguish: bool = true


func _ready() -> void:
	fire_sprite.visible = false
	set_process(true)
	set_monitoring(true)

func _process(delta: float) -> void:
	if not is_burning:
		for body in get_overlapping_bodies():
			if body.name == "lighter" and body.fire_sprite.visible:
				burn_timer += delta
				#var candle = get_node("Candle")
				#var frames = candle.sprite_frames.get_frame_count("glow")
				#var fps = frames / required_burn_time
				#candle.speed_scale = fps / candle.sprite_frames.get_animation_speed("glow")
				#candle.play("glow")
				await get_tree().create_timer(required_burn_time).timeout
				#candle.stop()
				if burn_timer >= required_burn_time:
					ignite()
	else:
		extinguish_timer += delta
		if extinguish_timer >= extinguish_delay:
			extinguish()

func ignite() -> void:
	is_burning = true
	fire_sprite.visible = true
	fire_sprite.play("fire")
	extinguish_timer = 0.0
	print(name, " brennt!")

func extinguish() -> void:
	if not should_extinguish:
		return
	is_burning = false
	fire_sprite.visible = false
	burn_timer = 0.0
	print(name, " ist ausgegangen.")

func lock_flame_on() -> void:
	should_extinguish = false
	print(name, " bleibt dauerhaft an.")

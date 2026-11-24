extends AnimatedSprite2D

@onready var timer: Timer = $Timer

var fps: float

func _ready() -> void:
	fps = sprite_frames.get_frame_count("timer") / timer.wait_time

func _process(delta: float) -> void:
	speed_scale = fps / sprite_frames.get_animation_speed("timer")
	

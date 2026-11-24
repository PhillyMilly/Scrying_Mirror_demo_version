extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play(Audio.song_position)
	process_mode = AudioStreamPlayer.PROCESS_MODE_ALWAYS

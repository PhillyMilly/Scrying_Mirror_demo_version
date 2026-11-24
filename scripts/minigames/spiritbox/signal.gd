extends Area2D
@onready var spiritbox: CharacterBody2D = $"../Spiritbox"
@onready var true_song: AudioStreamPlayer = $"../Spiritbox/AudioStreamPlayerTrue"
@onready var static_noise: AudioStreamPlayer = $"../Spiritbox/AudioStreamPlayerStatic"
@onready var spiritbox_root: Node2D = $".."

var is_true_signal: bool = false
var song: AudioStream

func _on_body_entered(body: Node2D) -> void:
	if body.name != "Spiritbox":
		return
	
	true_song.stream = song
	true_song.play()
	true_song.volume_db = 0
	
	spiritbox.in_area = true

	if is_true_signal and not spiritbox.song_found:
		spiritbox.song_found = true
		print("Richtige Position gefunden!")
		await get_tree().create_timer(3.5).timeout
		spiritbox_root.minigame_finished.emit(true)

func _on_body_exited(body: Node2D) -> void:
	if body.name != "Spiritbox":
		return


	true_song.stop()
	spiritbox.in_area = false

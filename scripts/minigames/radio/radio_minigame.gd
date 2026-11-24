extends Node2D

@onready var static_noise = $AudioStreamPlayerStatic
@onready var true_song = $AudioStreamPlayerTrue
@onready var fake1 = $AudioStreamPlayerFake1
@onready var fake2 = $AudioStreamPlayerFake2
@onready var knob = $RadioKnob
@onready var freq_label = $Label

var min_freq := 88.0
var max_freq := 108.0

var current_freq = min_freq
var true_freq = 0.0
var fake_freqs = []

var detection_range = 2.0
var lock_range = 0.2
var hold_time = 2.0
var timer = 0.0
var song_found = false

signal minigame_finished(success: bool)

func _ready():
	randomize()

	# Wahre Frequenz zufällig im Bereich
	true_freq = randf_range(min_freq + 2.0, max_freq - 2.0)

	# Fake-Frequenzen in der Nähe, aber mit Abstand zur echten
	fake_freqs.clear()
	while fake_freqs.size() < 2:
		var fake = randf_range(min_freq + 1.0, max_freq - 1.0)
		if abs(fake - true_freq) > 2.5:
			fake_freqs.append(fake)
	print("True Freq: %.1f | Fake1: %.1f | Fake2: %.1f" % [true_freq, fake_freqs[0], fake_freqs[1]])
	knob.connect("frequency_changed", _on_frequency_changed)
	static_noise.play()
	true_song.play()
	fake1.play()
	fake2.play()
	true_song.volume_db = -80
	fake1.volume_db = -80
	fake2.volume_db = -80

func _process(delta):
	update_audio()
	update_label()
	check_frequency_lock(delta)

func _on_frequency_changed(freq: float):
	current_freq = freq

func update_audio():
	# Nähe zum True-Song
	var dist_true = abs(current_freq - true_freq)
	var static_true_clarity = clamp(1.0 - dist_true / detection_range, 0.0, 1.0)

	# Nähe zu Fake-Songs (höchster Wert zählt)
	var static_fake_clarity = 0.0
	for fake_freq in fake_freqs:
		var dist_fake = abs(current_freq - fake_freq)
		var clarity = clamp(1.0 - dist_fake / detection_range, 0.0, 1.0)
		static_fake_clarity = max(static_fake_clarity, clarity)

	# Berechnung der Rauschlautstärke:
	# True Song -> am leisesten (-60 dB)
	# Fake Song -> mittlere Lautstärke (-45 dB)
	# Sonst -> laut (-25 dB)

	var static_volume = 1.0 - static_true_clarity  # Leiser bei echtem Song
	if static_fake_clarity > static_true_clarity:
		static_volume = 1.0 - static_fake_clarity * 0.5  # etwas leiser bei Fakes, aber nicht so stark

	# Immer etwas hörbar: zwischen -60 dB und -25 dB
	static_noise.volume_db = lerp(-50, -20, static_volume)

	# Musiklautstärke
	true_song.volume_db = lerp(-50, -5, static_true_clarity)

	for i in range(fake_freqs.size()):
		var fake_freq = fake_freqs[i]
		var dist = abs(current_freq - fake_freq)
		var vol = clamp(1.0 - dist / detection_range, 0.0, 1.0)
		var fake_volume = lerp(-50, -5, vol)
		if i == 0:
			fake1.volume_db = fake_volume  
		elif i == 1:
			fake2.volume_db = fake_volume

func check_frequency_lock(delta):
	if abs(current_freq - true_freq) <= lock_range:
		timer += delta
		if timer >= hold_time and not song_found:
			song_found = true
			print("Richtige Frequenz gefunden!")
			knob.set_process_input(false)
			knob.set_process_unhandled_input(false)
			knob.frequency_changed.disconnect(_on_frequency_changed) # ✅ korrekt in Godot 4
			minigame_finished.emit(true)
	else:
		timer = 0.0

func update_label():
	if freq_label:
		freq_label.text = str(snapped(current_freq, 0.1))

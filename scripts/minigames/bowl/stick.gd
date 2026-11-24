extends CharacterBody2D

var charge := 0.0
var base_max_charge := 2.2
var max_charge := base_max_charge
var charge_speed := 1.8
var hit_speed := 1000.0
var is_charging := false
var is_striking := false

var original_position := Vector2.ZERO
var shake_intensity := 0.8

var max_reached_time := -1.0
var perfect_window := 0.25

var can_charge := true
var game_finished := false

@onready var bowl: Node = get_parent().get_node("bowl")

# Audio-Nodes
@onready var sound_perfect: AudioStreamPlayer = $Perfect
@onready var sound_high: AudioStreamPlayer = $Hi
@onready var sound_low: AudioStreamPlayer = $Low

func _ready():
	original_position = position
	randomize_max_charge()

func _physics_process(delta: float) -> void:
	if game_finished:
		return

	# Wenn der Spieler lädt
	if Input.is_action_pressed("mouse_left") and not is_striking and can_charge:
		is_charging = true
		charge += charge_speed * delta
		charge = clamp(charge, 0.0, max_charge)

		# Wenn der Ladewert noch nicht maximal erreicht ist
		if charge < max_charge:
			position.x += 10 * delta
			original_position = position
		else:
			# Shaken bereits starten, wenn 95% von max_charge erreicht sind
			var shake_start_threshold := max_charge * 0.95  # Frühzeitiges Feedback ab 95%
			if charge >= shake_start_threshold:
				var shake = Vector2(randf_range(-shake_intensity, shake_intensity),
									randf_range(-shake_intensity, shake_intensity))
				position = original_position + shake

			if max_reached_time == -1.0 and charge >= max_charge:
				max_reached_time = Time.get_ticks_msec() / 1000.0

	# Wenn der Spieler loslässt
	elif Input.is_action_just_released("mouse_left") and is_charging:
		is_striking = true
		is_charging = false
		can_charge = false
		var now = Time.get_ticks_msec() / 1000.0
		var result := ""
		var wait_time := 1.0

		# Ergebnis basierend auf dem Ladezustand
		if charge < max_charge:
			result = "Zu wenig!"
			wait_time = 1.0
		else:
			var held_time = now - max_reached_time
			if held_time <= perfect_window:
				result = "Perfekt!"
				wait_time = 3.0
			else:
				result = "Zu viel!"
				wait_time = 2.0

		print(result)

		# Schlag ausführen
		velocity.x = -charge / max_charge * hit_speed
		charge = 0.0
		max_reached_time = -1.0
		position = original_position

		handle_result(result, wait_time)

	if is_striking:
		var collision = move_and_collide(velocity * delta)
		if collision:
			velocity = Vector2.ZERO
			is_striking = false

func handle_result(result: String, wait_time: float) -> void:
	if result == "Perfekt!":
		game_finished = true
		sound_perfect.play()
	elif result == "Zu viel!":
		sound_high.play()
		if bowl:
			bowl.start_shake(wait_time, 2.0)  # Kräftiger Shake
	elif result == "Zu wenig!":
		sound_low.play()
		if bowl:
			bowl.start_shake(wait_time, 1.0)  # Sanfter Shake

	await get_tree().create_timer(wait_time).timeout

	if result != "Perfekt!":
		can_charge = true
		randomize_max_charge()

func randomize_max_charge():
	var variation = randf_range(-0.7, 0.5)
	max_charge = clamp(base_max_charge + variation, 0.1, 10.0)

	# Dynamisch angepasstes Perfect-Fenster mit stärkerer Zufälligkeit
	perfect_window = lerp(0.2, 0.4, (max_charge - 1.5) / (2.7 - 1.5))  # Basiswerte
	perfect_window += randf_range(-0.3, 0.3)  # Größere zufällige Variation (positiv oder negativ)
	perfect_window = clamp(perfect_window, 0.05, 0.7)  # Sicherstellen, dass es im gewünschten Bereich bleibt

	print("🎯 Neue max_charge:", max_charge, "| 🕒 perfect_window:", perfect_window)

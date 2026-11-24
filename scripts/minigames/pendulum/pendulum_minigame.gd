extends Node

signal minigame_finished(success: bool)

var combo_sequence := ["right", "middle", "left", "middle"]
var current_index := 0
var left_hits := 0
var right_hits := 0
var combo_active := true
var answer
var last_hit_side := ""  # Verhindert doppeltes Abspielen

# Reihenfolge der Noten
var note_sequence := ["C4", "D4", "E4", "F4", "G4", "A4", "B4", "C5", "D5", "E5"]

# Mapping der Notennamen zu den AudioStreamPlayer-Nodes
var note_players := {}

@onready var rope_holder: CharacterBody2D = $rope_holder

func _ready() -> void:
	# Mappe alle Combo-Player (z. B. DCombo, D#Combo, etc.)
	for note in note_sequence:
		var node_name = note
		if rope_holder.has_node(node_name):
			note_players[note] = rope_holder.get_node(node_name)
		else:
			print("⚠️ Hinweis: Kein AudioPlayer für Note:", note)

func register_hit(area_name: String) -> void:
	if not combo_active:
		return

	var expected = combo_sequence[current_index]
	print("Erwartet:", expected, "| Eingegangen:", area_name)

	# Mittel-Hitbox: Reset für "last_hit_side", keine Note
	if area_name == "middle":
		if expected != "middle":
			print("❌ Middle wurde unerwartet getroffen.")
			reset_combo()
			return
		current_index = (current_index + 1) % combo_sequence.size()
		last_hit_side = ""  # Reset der Sperre
		print("✅ Richtig: middle | Fortschritt: ", left_hits, "x Links /", right_hits, "x Rechts")
		return

	# Richtige Hitbox prüfen
	if area_name != expected:
		print("❌ Falsche Reihenfolge! Combo zurückgesetzt.")
		reset_combo()
		return

	# Gleiche Seite doppelt?
	if area_name == last_hit_side:
		print("⏸️ Gleiche Seite doppelt getroffen, warte auf middle.")
		return

	# Treffer zählen und Ton abspielen
	if area_name == "left":
		left_hits += 1
	elif area_name == "right":
		right_hits += 1

	# Combo-Fortschritt & Ton
	var combo_step = left_hits + right_hits - 1
	play_note(combo_step)

	last_hit_side = area_name
	current_index = (current_index + 1) % combo_sequence.size()
	print("✅ Richtig:", area_name, "| Fortschritt: ", left_hits, "x Links /", right_hits, "x Rechts")

	if left_hits >= 5 and right_hits >= 5:
		combo_active = false
		disable_rope_holder()
		minigame_finished.emit(true)
		print("🎉 Spiel geschafft!")

func play_note(combo_step: int) -> void:
	var index = clamp(combo_step, 0, note_sequence.size() - 1)
	var note = note_sequence[index]
	if note in note_players:
		note_players[note].play()
		print("🎵 Spiele Note:", note)
	else:
		print("❌ Kein Player für Note:", note)

func reset_combo() -> void:
	current_index = 0
	left_hits = 0
	right_hits = 0
	last_hit_side = ""
	print("🔁 Combo zurückgesetzt.")

func disable_rope_holder() -> void:
	if rope_holder:
		# Eingaben & Physik deaktivieren
		rope_holder.set_process(false)
		rope_holder.set_physics_process(false)
		rope_holder.set_process_input(false)
		rope_holder.set_process_unhandled_input(false)
		rope_holder.set_process_unhandled_key_input(false)

		# Falls vorhanden: Collider deaktivieren
		for child in rope_holder.get_children():
			if child is CollisionShape2D or child is CollisionPolygon2D:
				child.disabled = true

		# Optional: Visuelles Feedback oder weitere Logik
		if rope_holder.has_method("set_disabled"):
			rope_holder.set_disabled(true)

		print("🚫 Rope Holder deaktiviert.")

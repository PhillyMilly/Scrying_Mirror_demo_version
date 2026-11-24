extends Node2D

@onready var glas: CharacterBody2D = $glas
@onready var mouse: CharacterBody2D = $mouse

signal minigame_finished(success: bool)

var verfolgungszeit_erforderlich = 5.0
var verfolgungszeit_aktuell = 0.0
var bewegungsgeschwindigkeit = 190.0
var bewegungsrichtung = Vector2.ZERO
var zufallsrichtung_timer = 0.0
var zufallsrichtung_intervall = 1.5
var schuettel_staerke = 5.0
var schuettel_dauer = 0.3
var schuettel_timer = 0.0
var original_position = Vector2.ZERO

var move_bounds := Rect2(Vector2(-160, -90), Vector2(320, 180))
var zoom_factor := 1.0
var maus_ist_im_glas = false

func _ready():
	original_position = glas.position
	set_zufaellige_richtung()

	# Erkennung, wenn der CharacterBody2D "mouse" in das Glas eintritt/verlässt
	#glas.body_entered.connect(_on_glas_body_entered)
	#glas.body_exited.connect(_on_glas_body_exited)

func _process(delta):
	# 🐭 Maus-Charakter folgt der echten Maus
	#mouse.global_position =  get_global_mouse_position()

	# Verfolgungszeit erhöhen oder zurücksetzen
	if maus_ist_im_glas:
		verfolgungszeit_aktuell += delta
		if verfolgungszeit_aktuell >= verfolgungszeit_erforderlich:
			finish()
			# Hier kannst du einmalige Aktionen starten
	else:
		if verfolgungszeit_aktuell > 0:
			schuettle_glas_kurz()
		verfolgungszeit_aktuell = 0.0

	# Schütteln
	if schuettel_timer > 0:
		schuettel_timer -= delta
		if schuettel_timer <= 0:
			glas.position = original_position
		else:
			glas.position = original_position + Vector2(
				randf_range(-schuettel_staerke, schuettel_staerke),
				randf_range(-schuettel_staerke, schuettel_staerke)
			)
	else:
		# Bewegung
		zufallsrichtung_timer += delta
		if zufallsrichtung_timer >= zufallsrichtung_intervall:
			set_zufaellige_richtung()
			zufallsrichtung_timer = 0.0
		glas.position += bewegungsrichtung * bewegungsgeschwindigkeit * delta

		var scaled_move_bounds = Rect2(move_bounds.position / zoom_factor, move_bounds.size / zoom_factor)
		glas.position.x = clamp(glas.position.x, scaled_move_bounds.position.x, scaled_move_bounds.position.x + scaled_move_bounds.size.x)
		glas.position.y = clamp(glas.position.y, scaled_move_bounds.position.y, scaled_move_bounds.position.y + scaled_move_bounds.size.y)

func finish():
	set_process(false)
	print("✅ Verfolgung erfolgreich!")
	minigame_finished.emit(true)
	
	
func set_zufaellige_richtung():
	bewegungsrichtung = Vector2(randf_range(-1, 1), randf_range(-1, 1))

func schuettle_glas_kurz():
	original_position = glas.position
	schuettel_timer = schuettel_dauer

# Wird aufgerufen, wenn ein Körper das Glas betritt
func _on_glas_body_entered(body):
	#if body == mouse:
	maus_ist_im_glas = true

# Wird aufgerufen, wenn ein Körper das Glas verlässt
func _on_glas_body_exited(body):
	#if body == mouse:
	maus_ist_im_glas = false

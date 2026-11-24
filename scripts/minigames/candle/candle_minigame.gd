extends Node2D

signal minigame_finished(success: bool)

@onready var lighter: CharacterBody2D = $lighter
@onready var candle_0: Candle = $candle0
@onready var candle_1: Candle = $candle1
@onready var candle_2: Candle = $candle2


var all_candles_burning:	bool = false

func _ready() -> void:
	var candles:	Array[Node] = [candle_0, candle_1, candle_2]
	var times:		Array[float] = [0.8, 1.5, 2.3]
	times.shuffle()
	for i in range(candles.size()):
		candles[i].required_burn_time = times[i]
		print("%s braucht %.2f Sekunden" % [candles[i].name, times[i]])

func _process(_delta: float) -> void:
	if all_candles_burning:
		return # schon gewonnen, nicht nochmal prüfen

	if candle_0.is_burning and candle_1.is_burning and candle_2.is_burning:
		all_candles_burning = true

		# STOPPE das Ausgehen der Kerzen
		candle_0.lock_flame_on()
		candle_1.lock_flame_on()
		candle_2.lock_flame_on()

		print("Alle brennen gleichzeitig! Du hast gewonnen!")
		minigame_finished.emit(true)

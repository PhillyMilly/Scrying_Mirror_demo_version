extends Node2D

signal shop_exited(data: Dictionary)  # Neues Signal oben

@onready var character = $Character2D
@onready var salt = $salt
@onready var ouja = $ouja
@onready var crystal = $crystal
@onready var candle = $candle
@onready var battery = $battery
@onready var exit = $exit  # Exit-Node

var gold = 0
var inventory = {
	"salt": 0,
	"battery": 0,
	"candle": 0,
	"ouja": false,
	"crystal": false
}

var prices = {
	"salt": 3,
	"battery": 3,
	"candle": 3,
	"ouja": 10,
	"crystal": 15
}

func _process(delta):
	# Spieler folgt Mausposition
	character.global_position = get_global_mouse_position()

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		check_purchase()
	elif event is InputEventKey and event.pressed and event.keycode == KEY_UP:
		gold += 5
		print("Gold:", gold)

func check_purchase():
	var mouse_pos = get_global_mouse_position()

	for item in ["salt", "battery", "candle", "ouja", "crystal"]:
		var area = get_node(item)
		if area.get_overlapping_bodies().has(character):
			buy_item(item)
	
	# Prüfe Exit-Bereich
	if exit.get_overlapping_bodies().has(character):
		emit_signal("shop_exited", {
			"inventory": inventory.duplicate(),
			"gold": gold
		})
		print("Shop verlassen mit:", inventory, "| Gold:", gold)

func buy_item(item_name):
	var cost = prices[item_name]

	if gold < cost:
		print("Nicht genug Gold für", item_name)
		return

	match item_name:
		"salt", "battery", "candle":
			gold -= cost
			inventory[item_name] += 1
			print("Gekauft:", item_name, "| Neu:", inventory[item_name], "| Gold:", gold)

		"ouja", "crystal":
			if inventory[item_name]:
				print(item_name, "bereits gekauft!")
				return
			gold -= cost
			inventory[item_name] = true

			# Deaktiviere das Item ohne es zu löschen
			var node = get_node(item_name)
			if node is Area2D:
				node.monitoring = false  # Kein Überlapp mehr möglich
				if node.has_node("Sprite2D"):
					node.get_node("Sprite2D").modulate = Color(1, 1, 1, 0.4)  # Halbtransparent

			print("Gekauft:", item_name, "| Gold:", gold)

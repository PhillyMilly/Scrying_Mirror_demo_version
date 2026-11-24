extends Node


var		slots: Dictionary = {
	"Slot": "empty",
	"Slot2": "empty",
	"Slot3": "empty",
	"Slot4": "empty",
	"Slot5": "empty",
	"Slot6": "empty",
	"Slot7": "empty",
	"Slot8": "empty",
	"Slot9": "empty",
	"Slot10": "empty",
	"Slot11": "empty",
	"Slot12": "empty",
	"Slot13": "empty",
	"Slot14": "empty",
	"Slot15": "empty",
	"Slot16": "empty",
	"Slot17": "empty",
	"Slot18": "empty"
};

func add_item(position: String, name: String):
	slots[position] = name;

func remove_item(position: String):
	slots[position] = "empty";

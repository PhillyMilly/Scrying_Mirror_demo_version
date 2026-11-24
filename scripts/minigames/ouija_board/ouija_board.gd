extends Node2D

var str:	String = ""
var answer:	String = ""
signal minigame_finished(success: bool)

func _ready() -> void:
	answer = Dialog.truncate(answer)
	print(answer)

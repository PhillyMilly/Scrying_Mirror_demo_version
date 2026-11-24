extends Node2D

var table:	PackedScene


func _on_tutorialma_pressed() -> void:
	set_job(0)
	get_tree().change_scene_to_file("res://scenes/table/table.tscn")


func _on_tbd_pressed() -> void:
	set_job(1)
	get_tree().change_scene_to_file("res://scenes/table/table.tscn")

func set_job(i: int) -> void:
	Dialog.client = Dialog.client_names[i]
	Dialog.request = Dialog.requests[i]
	Dialog.question = Dialog.questions[i]
	Dialog.fail_reaction = Dialog.fail_reactions[i]
	Dialog.solved_reaction = Dialog.success_reactions[i]
	Dialog.finish = Dialog.end[i]
	
	Dialog.ghost = Dialog.ghost_names[i]
	Dialog.unsolved = Dialog.answers[i]
	Dialog.unsolved_types = Dialog.types[i]
	Dialog.ouija_fail = Dialog.ouija_fails[i]
	
	Dialog.solved = []

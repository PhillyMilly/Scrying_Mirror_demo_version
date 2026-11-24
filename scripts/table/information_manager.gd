extends Node

@onready var job_manager: Node = $".."
@onready var minigame_manager: Control = $"../MinigameManager"
@onready var dialog_area: RichTextLabel = $"../../DialogArea"

var success_rate:	int
var unsolved_left:	int
var current:		int
#var effectiveness:	Dictionary = {
	#"words/numbers":	{ "crystalorb": 0,		"ouija": 100,	"spiritbox": 0 },
	#"sound":			{ "crystalorb": 0,		"ouija": 0,		"spiritbox": 100 },
	#"see":				{ "crystalorb": 100,	"ouija": 0,		"spiritbox": 0 },
	#"other":			{ "crystalorb": 100,	"ouija": 100,	"spiritbox": 100 }
#}

signal start_information_minigame(id: String, to_solve: String)
signal finish_job()

func _ready() -> void:
	success_rate = 0
	unsolved_left = Dialog.unsolved.size()
	job_manager.connect("start_minigame", Callable(self, "_start_information_minigame"))
	minigame_manager.connect("minigame_result", Callable(self, "_finish_information_minigame"))

#func get_effectivness(minigame: String, answer_type: String) -> int:
	#return (effectiveness[answer_type][minigame])

func start_if(current_game: String, compare: String, type: String, fail_str: String):
	if current_game == compare:
		current = Dialog.unsolved_types.find(type)
		dialog_area.current = current
		if current == -1:
			start_information_minigame.emit(current_game, fail_str)
		else:
			start_information_minigame.emit(current_game, Dialog.unsolved[current])

func _start_information_minigame(current_minigame: String) -> void:
	start_if(current_minigame, "ouija", Dialog.words, Dialog.ouija_fail)
	start_if(current_minigame, "crystalorb", Dialog.see, "fail")
	start_if(current_minigame, "spiritbox", Dialog.sound, "fail")

func _finish_information_minigame(success: bool, current_minigame: String):
	if current_minigame == "ouija" or current_minigame == "crystalorb" or current_minigame == "spiritbox":
		if current != -1 && success:
			Dialog.after_minigame = Dialog.solved_reaction[current]
			Dialog.solved.append(Dialog.unsolved[current])
			Dialog.unsolved.remove_at(current)
			Dialog.unsolved_types.remove_at(current)
			Dialog.question.remove_at(current)
			Dialog.solved_reaction.remove_at(current)
			unsolved_left = Dialog.unsolved.size()
		elif success:
			if current == -1:
				if current_minigame == "spiritbox":
					Dialog.after_minigame = Dialog.fail_reaction[0]
				elif current_minigame == "ouija":
					Dialog.after_minigame = Dialog.fail_reaction[1]
				elif current_minigame == "crystalorb":
					Dialog.after_minigame = Dialog.fail_reaction[2]	
				Dialog.after_minigame.append("You: \n...That wasn't really helpfull.")
				Dialog.after_minigame.append("You: \nMaybe i should try a different tool.")
		else:
			Dialog.after_minigame = ["You: \nI couldn't quite make up the words..."]
		if !unsolved_left:
			for str in Dialog.finish:
				Dialog.after_minigame.append(str)
			finish_job.emit()

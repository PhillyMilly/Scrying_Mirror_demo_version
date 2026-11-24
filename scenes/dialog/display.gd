extends RichTextLabel

@onready var job_manager: Node = $"../JobManager"
@onready var text_noise: AudioStreamPlayer = $TextNoise

var i:				int = 0
var is_writing:		bool = false
var dialog:			Array[String]
var visible_text:	String = ""
var speed:			float
var current:		int = 0
var flavor_text:	bool

func _ready() -> void:
	bbcode_enabled = true
	speed = 0.03
	dialog = Dialog.request
	print_dialog()

func _process(delta: float) -> void:
	if Input.is_action_pressed("mouse_left") && is_writing && !flavor_text:
		speed = 0
	if Input.is_action_just_pressed("mouse_left") && dialog && !is_writing && !flavor_text:
		print_dialog()
	if Input.is_action_just_released("mouse_left"):
		speed = 0.03

func change_dialog(current_dialog: Array[String]) -> void:
	i = 0
	dialog = current_dialog

func print_dialog() -> void:
	if i < dialog.size() && !is_writing:
		is_writing = true
		get_tree().paused = true
		var full_text := dialog[i]
		var newline_index := full_text.find("\n")
		if newline_index == -1:
			newline_index = 0

		# Show the initial static part
		visible_text = full_text.substr(0, newline_index + 1)
		text = visible_text

		var current_index := newline_index + 1

		while current_index < full_text.length():
			# Handle BBCode tags instantly
			if full_text[current_index] == "[":
				var tag_end := full_text.find("]", current_index)
				if tag_end != -1:
					var tag := full_text.substr(current_index, tag_end - current_index + 1)
					visible_text += tag
					current_index = tag_end + 1
					text = visible_text
					continue

			# Add next character
			visible_text += full_text[current_index]
			text = visible_text
			if full_text[current_index] != ".":
				text_noise.play()
			current_index += 1
			await get_tree().create_timer(speed).timeout
			text_noise.stop()

		i += 1
	else:
		text = ""
		get_tree().paused = false
	is_writing = false

func _on_job_manager_sig_lost_contact() -> void:
	change_dialog(["You: \n*shoot* I lost contact to the ghost!"])
	print_dialog()

func _on_minigame_manager_minigame_result(success: bool, id: String) -> void:
	await get_tree().create_timer(0.5).timeout
	if id in ["crystalorb", "ouija", "spiritbox"]:
		change_dialog(Dialog.after_minigame)
		print_dialog()


func _on_job_manager_start_minigame(minigame_id: String) -> void:
	if minigame_id == "ouija":
		flavor_text = true
		current = Dialog.unsolved_types.find(Dialog.words)
		if current == -1:
			current = randi_range(0, Dialog.question.size() - 1)
		change_dialog([
			"You tried to reach " + Dialog.ghost,
			"...",
			"and succeeded!",
			"You asked " + Dialog.ghost + " a question " + Dialog.question[current] + "."
			])
		print_dialog()
		await get_tree().create_timer(1.8).timeout
		speed = 1
		print_dialog()
		speed = 0.03
		await get_tree().create_timer(3).timeout
		print_dialog()
		await get_tree().create_timer(1).timeout
		print_dialog()
		await get_tree().create_timer(2).timeout
		print_dialog()
		flavor_text = false


func _on_game_manager_sig_cause_of_death(cause_of_death: int):
	if cause_of_death == 1:
		change_dialog(["You were not careful enough and angered the ghost..."])
	if cause_of_death == 2:
		change_dialog(["You ran out of time..."])
	print_dialog()

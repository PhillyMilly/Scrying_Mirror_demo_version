extends Node

@onready var job_manager:			Node = %JobManager
@onready var minigame_manager:		Control = %MinigameManager
@onready var ghost_bar_manager:		Control = %GhostBarManager
@onready var ui:					Control = %UI
@onready var dialog_area: RichTextLabel = $"../DialogArea"
@onready var ghost_bar_container: Control = $"../UI/GhostBarContainer"
@onready var job_timer: Timer = $"../JobManager/JobTimer"

signal sig_cause_of_death(cause_of_death: int)

@export_category("Ghost Type")
@export_enum("shy", "normal", "aggressive") var ghost_type : String = "normal"

@export_category("Ghost Data Resource Files")
@export var shy_ghost_data:			Resource
@export var normal_ghost_data:		Resource
@export var aggressive_ghost_data:	Resource


var ghost_data_map:					Dictionary

func _ready() -> void:
	ghost_bar_manager.connect("aggression_full", Callable(self, "trigger_job_failed"))
	ghost_bar_container.connect("aggression_full", Callable(self, "trigger_job_failed"))
	
	ghost_data_map = {
		"shy":			shy_ghost_data			as GhostData,
		"normal":		normal_ghost_data		as GhostData,
		"aggressive":	aggressive_ghost_data	as GhostData,
	}
	await minigame_manager.ready
	await ghost_bar_manager.ready
	await ui.ready
	start_1st_job()
	job_timer.timeout.connect(_on_job_timer_timeout)

func start_1st_job() -> void:
	job_manager.init_job(ghost_type, ghost_data_map[ghost_type])
	ghost_bar_manager.current_ghost_data = ghost_data_map[ghost_type]


func trigger_job_failed(cause_of_death: int) -> void:
	# TODO:
	#	Fade out
	#	Transition to game over screen
	#	fade into table scene before alma talks
	if cause_of_death ==  1:
		job_manager.job_timer.stop()
	if cause_of_death == 2:
		pause_bars()
	#sig_cause_of_death.emit(cause_of_death)
	# WARNING:	Waiting here is not the best solution right now, 
	#			but else it will reload the scene_tree too quick.
	#			Maybe Game Over Scene will fix it
	#await get_tree().create_timer(4).timeout
	get_tree().change_scene_to_file("res://scenes/gameover.tscn")


func pause_bars() -> void:
	if ghost_bar_manager.is_processing() == true:
		ghost_bar_manager.set_process(false)


func resume_bars() -> void:
	if ghost_bar_manager.is_processing() == false:
		ghost_bar_manager.set_process(true)


func reset_bars() -> void:
	ghost_bar_manager.contact = 0.0
	ghost_bar_manager.maintain = 0.0
	ghost_bar_manager.aggression = 0.0


func close_minigame() -> void:
	minigame_manager._close_minigame()


func finish_minigame() -> void:
	minigame_manager._on_minigame_finished(true)
	
	
func _on_pause_bars_pressed() -> void:
	pause_bars()

func _on_resume_bars_pressed() -> void:
	resume_bars()

func _on_close_minigame_pressed() -> void:
	close_minigame()

func _on_finish_minigame_pressed() -> void:
	finish_minigame()

func _on_fail_pressed() -> void:
	trigger_job_failed(1)

func _on_job_timer_timeout():
	trigger_job_failed(2)


func _on_information_manager_finish_job() -> void:
	get_tree().change_scene_to_file("res://scenes/thanks_for_playing.tscn")

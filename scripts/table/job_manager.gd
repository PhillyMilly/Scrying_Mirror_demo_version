extends Node

@onready var ui: 				Control = $"../UI"
@onready var game_manager:		Node = %GameManager
@onready var minigame_manager:	Control = %MinigameManager
@onready var ghost_bar_manager:	Control = %GhostBarManager
@onready var job_timer:			Timer = $JobTimer
@onready var close_minigame_timer: Timer = $CloseMinigameTimer

############### Signals ###############
#	Gameplay Related
signal sig_lost_contact()
signal sig_gained_contact(first_contact: bool)

#	Control Related
signal sig_update_bars(success: bool, minigame_id: String, ghost_type: String)
signal sig_toggle_tools(phase: int)
signal start_minigame(minigame_id: String)
signal close_minigame()

# Globals
@export var current_phase:			int = 1
@export var job_time:				float = 180
@export var shy_ghost_data:			Resource
@export var normal_ghost_data:		Resource
@export var aggressive_ghost_data:	Resource

var ghost_data_map:					Dictionary
var first_contact:					bool = true

# Variables to set for incoming Job Type
var current_ghost_type:				String
var current_ghost_data:				GhostData
var has_job_timer_started:				bool


func init_job(ghost_type: String, ghost_data: GhostData) -> void:
	if not ui.is_connected("item_used", Callable(self, "_start_minigame")):
		ui.connect("item_used", Callable(self, "_start_minigame"))
	if not minigame_manager.is_connected("minigame_result", Callable(self, "_evaluate_result")):
		minigame_manager.connect("minigame_result", Callable(self, "_evaluate_result"))
	if not ghost_bar_manager.is_connected("phase_shift", Callable(self, "_update_phase")):
		ghost_bar_manager.connect("phase_shift", Callable(self, "_update_phase"))
	
	current_ghost_type = ghost_type
	current_ghost_data = ghost_data
	
	job_timer.wait_time = job_time
	first_contact = true
	start_job(current_ghost_type)


func start_job(ghost_type: String):
	ui._toggle_tools(1)
	job_timer.start()
	has_job_timer_started = true
	
	
func _start_minigame(item_used: String) -> void:
	start_minigame.emit(item_used)


func _update_phase(phase: int):
	current_phase = phase
	sig_toggle_tools.emit(current_phase)
	if current_phase == 1:
		sig_lost_contact.emit()
		close_minigame.emit()
	if current_phase == 2:
		if first_contact == false:
			sig_gained_contact.emit(false)
		if first_contact == true:
			sig_gained_contact.emit(true)
			first_contact = false


func _evaluate_result(success: bool, minigame_id: String):
	ghost_bar_manager.update_bars(success, minigame_id, current_ghost_type)
	game_manager.pause_bars()
	close_minigame_timer.start()
	await close_minigame_timer.timeout
	game_manager.resume_bars()
	
	minigame_manager._close_minigame()

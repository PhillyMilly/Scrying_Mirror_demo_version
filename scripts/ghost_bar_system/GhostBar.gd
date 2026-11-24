extends Control

# Nodes
@onready var job_manager: Node = %JobManager
@onready var minigame_manager: Control = %MinigameManager

# Signals
signal phase_shift(phase: int)
signal aggression_full(game_over_value: int)

# Globals
@onready var current_ghost_data:	GhostData
const MAINTAIN_DECAY_RATE := 0.1
const CONTACT_AUTO_FILL := 0.5
const AGGRO_AUTO_FILL := 2.0
const TICK_DELAY := 0.05
var was_shadow_full:	bool = false
var decay_timer := 0.0

@export var BASE_MAINTAIN: float = 50.0
@export var contact:			float:
	set(new_value):
		contact = clampf(new_value, 0.0, 100.0)
	get:
		return contact

@export var maintain:			float:
	set(new_value):
		maintain = clampf(new_value, 0.0, 100.0)
	get:
		return maintain
		
@export var aggression:			float:
	set(new_value):
		aggression = clampf(new_value, 0.0, 100.0)
	get:
		return aggression


func _ready():
	contact = 0.0
	maintain = 0.0
	aggression = 0.0
	job_manager.connect("sig_update_bars", Callable(self, "_update_bars"))
	set_process(true)

func _process(delta):
	# Check for shadow → contact transition
	if contact == 100.0 and not was_shadow_full:
		phase_shift.emit(2)
		# Übergabe nur einmal bei Erreichen von 100
		maintain = BASE_MAINTAIN
		was_shadow_full = true
	elif contact < 100.0:
		was_shadow_full = false

	# Kontakt-Bar zerfällt langsam && Shadow-Bar steigt langsam an
	if maintain > 0.0 and was_shadow_full:
		decay_timer += delta
		while decay_timer >= TICK_DELAY:
			decay_timer -= TICK_DELAY
			maintain -= MAINTAIN_DECAY_RATE * current_ghost_data.maintain_multiplier
			aggression += AGGRO_AUTO_FILL * TICK_DELAY * current_ghost_data.aggression_multiplier

			if maintain == 0.0:
				phase_shift.emit(1)
				contact = 0.0
			if aggression == 100.0:
				_aggression_full()

# NOTE: Wrapper Function for increasing decreasing bars
func update_bars(success: bool, minigame_id: String, ghost_type: String) -> void:
	match minigame_id:
		"candlelight":
			_increase_contact_bar(minigame_id, ghost_type, current_ghost_data.contact_values[GhostData.ContactItem.CANDLE])
			_increase_aggression_bar(minigame_id, ghost_type, current_ghost_data.aggression_values[GhostData.ContactItem.CANDLE])
		"pendulum":
			_increase_contact_bar(minigame_id, ghost_type, current_ghost_data.contact_values[GhostData.ContactItem.PENDULUM])
			_increase_aggression_bar(minigame_id, ghost_type, current_ghost_data.aggression_values[GhostData.ContactItem.PENDULUM])
		"glass":
			_increase_contact_bar(minigame_id, ghost_type, current_ghost_data.contact_values[GhostData.ContactItem.GLASS])
			_increase_aggression_bar(minigame_id, ghost_type, current_ghost_data.aggression_values[GhostData.ContactItem.GLASS])
		"bowl":
			_increase_maintain_bar(minigame_id, ghost_type, current_ghost_data.maintain_values[GhostData.MaintainItem.BOWL])
			_increase_aggression_bar(minigame_id, ghost_type, current_ghost_data.aggression_values[GhostData.MaintainItem.BOWL])
		"radio":
			_increase_maintain_bar(minigame_id, ghost_type, current_ghost_data.maintain_values[GhostData.MaintainItem.RADIO])
			_increase_aggression_bar(minigame_id, ghost_type, current_ghost_data.aggression_values[GhostData.MaintainItem.RADIO])
		"saltcircle":
			_increase_maintain_bar(minigame_id, ghost_type, current_ghost_data.maintain_values[GhostData.MaintainItem.SALTCIRCLE])
			_increase_aggression_bar(minigame_id, ghost_type, current_ghost_data.aggression_values[GhostData.MaintainItem.SALTCIRCLE])
	if aggression == 100.0:
		_aggression_full()

func _increase_contact_bar(minigame_id: String, ghost_type: String, increase_value: float) -> void:
	contact += increase_value
	if contact == 100:
		maintain = BASE_MAINTAIN

func _increase_maintain_bar(minigame_id: String, ghost_type: String, increase_value: float) -> void:
	maintain += increase_value

func _increase_aggression_bar(minigame_id: String, ghost_type: String, increase_value: float) -> void:
	if aggression < 100:
		aggression += increase_value

func _aggression_full() -> void:
	aggression_full.emit(1)

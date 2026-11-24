extends Control

@onready var ghost_bar_manager: Control = %GhostBarManager
@onready var contact_bar: ProgressBar = $ContactBar
@onready var maintain_bar: ProgressBar = $MaintainBar
@onready var aggression_bar: ProgressBar = $AggressionBar
@onready var scrying_mirror: AnimatedSprite2D = $"../ScryingMirror"
@onready var time_left_label: Label = $TimeLeftLabel
@onready var job_timer: Timer = $"../../JobManager/JobTimer"
@onready var job_manager: Node = %JobManager

@onready var blink_agression: AnimatedSprite2D = $"../../blink_agression"
@onready var blink_contact: AnimatedSprite2D = $"../../blink_contact"

@export var ACTIVE_AGGRESSION_BAR_COLOR: Color
@export var INACTIVE_AGGRESSION_BAR_COLOR: Color

var style_box: StyleBoxFlat
var time_remaining: float

func _ready() -> void:
	for bar in [contact_bar, maintain_bar, aggression_bar]:
		bar.value = 0.0
		bar.max_value = 100.0
	maintain_bar.visible = false
	style_box = aggression_bar.get("theme_override_styles/fill")
	style_box.bg_color = INACTIVE_AGGRESSION_BAR_COLOR
	time_remaining = job_manager.job_time
	update_timer_label(time_remaining) # Initial display


	
func _process(delta: float) -> void:
	if !is_instance_valid(ghost_bar_manager):
		push_error("GhostBarManager not available in UI _process")
		return
	contact_bar.value = ghost_bar_manager.contact
	maintain_bar.value = ghost_bar_manager.maintain
	aggression_bar.value = ghost_bar_manager.aggression
	_update_left_ui(ghost_bar_manager.contact, ghost_bar_manager.maintain, ghost_bar_manager.aggression)
	if job_manager.has_job_timer_started == true:
		time_remaining -= delta
		if time_remaining < 0:
			time_remaining = 0 # Avoid negative display
			# You might want to stop the timer here as well if 'One Shot' is false
			# job_timer.stop()
		update_timer_label(time_remaining)


func _update_left_ui(contact: float, maintain: float, aggression: float) -> void:
	if aggression < 25:
		scrying_mirror.frame = 0
	if aggression >= 10 && aggression < 25:
		scrying_mirror.frame = 1
	if aggression >= 25 && aggression < 75:
		scrying_mirror.frame = 2
	if aggression >= 75 && aggression < 90:
		scrying_mirror.frame = 3
	if aggression >= 90:
		scrying_mirror.frame = 4
	if maintain < 25 && contact == 100:
		blink_contact.play()
		blink_contact.visible = true
	if maintain > 25 && contact == 100 && blink_contact.is_playing() == true:
		blink_contact.stop()
		blink_contact.visible = false
	if aggression >= 75:
		blink_agression.play()
		blink_agression.visible = true
	if aggression <= 75 && blink_agression.is_playing() == true:
		blink_agression.stop()
		blink_agression.visible = false


func _on_job_manager_sig_lost_contact() -> void:
	style_box.bg_color = INACTIVE_AGGRESSION_BAR_COLOR
	maintain_bar.visible = false


func _on_job_manager_sig_gained_contact(first_contact: bool) -> void:
	style_box.bg_color = ACTIVE_AGGRESSION_BAR_COLOR
	print("GAINED CONTACT ", first_contact)
	maintain_bar.visible = true


func update_timer_label(time_value: float):
	# Format the time value into a readable string (e.g., "mm:ss")
	var minutes = floor(time_value / 60)
	var seconds = fmod(time_value, 60)
	time_left_label.text = "%02d:%02d" % [minutes, seconds] # Example format

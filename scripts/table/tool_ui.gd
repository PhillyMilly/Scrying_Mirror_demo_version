extends Control

@onready var job_manager: Node = %JobManager
@onready var button_container: Control = $ButtonContainer
@onready var contact: Control = $ButtonContainer/Contact
@onready var maintain: Control = $ButtonContainer/Maintain
@onready var communicate: Control = $ButtonContainer/Communicate
@onready var click_item_2: AudioStreamPlayer = $"../ClickItem2"

# Signals
signal item_used(itme_name: String)
signal sig_close_minigame()

func _ready() -> void:
	# connecting all buttons
	for button in contact.get_children():
			button.connect("pressed", _on_button_pressed.bind(button.name.to_lower()))
	for button in maintain.get_children():
			button.connect("pressed", _on_button_pressed.bind(button.name.to_lower()))
	for button in communicate.get_children():
			button.connect("pressed", _on_button_pressed.bind(button.name.to_lower()))
	job_manager.connect("sig_toggle_tools", Callable(self, "_toggle_tools"))

# Change phase from 1, 2 or 3 to enable the tool category
# Change to 0 if no tool should be enabled
# Defaults to all enabled if Number is outside of range
func _toggle_tools(phase: int):
	print("toggling tools to ", phase)
	match phase:
		0:
			_disable_tool_category(false, false, false)
		1:
			_disable_tool_category(false, true, true)
		2:
			_disable_tool_category(true, false, false)
		3:
			_disable_tool_category(true, false, false)
		_:
			_disable_tool_category(true, true, true)

func _disable_tool_category(_contact: bool, _maintain: bool, _communicate: bool) -> void:
	
	for button in $ButtonContainer/Contact.get_children():
		button.disabled = _contact
	for button in $ButtonContainer/Maintain.get_children():
		button.disabled = _maintain
	for button in $ButtonContainer/Communicate.get_children():
		button.disabled = _communicate

func _on_button_pressed(item_name: String):
	click_item_2.play()
	item_used.emit(item_name)

extends CharacterBody2D

#Includes
#const GAME = preload("res://scenes/game.tscn")
@onready var target:			Area2D = $"../Target"
@onready var timer:				Timer = $"../TimeIndicator/Timer"
@onready var time_indicator:	AnimatedSprite2D = $"../TimeIndicator"
@onready var letters:			Node2D = $"../Letters"
@onready var ouija_board:		Node2D = $".."
@onready var finish_timer:		Timer = $"../FinishTimer"

#Variables
var is_hovering:	bool = false
var is_grabbed:		bool = false
var is_finished:	bool = false
var i:				int = 0

func _ready() -> void:
	is_finished = false
	input_pickable = true
	time_indicator.visible = false
	await get_tree().create_timer(10).timeout
	time_indicator.visible = true
	time_indicator.global_position = letters.get_node(ouija_board.answer[i]).global_position
	timer.start()
	time_indicator.play("timer")
	i += 1

func _physics_process(delta: float) -> void:
	if !is_finished:
		if Input.is_action_pressed("mouse_left") && is_hovering:
			is_grabbed = true
			target.visible = true
			target.global_position = target.get_global_mouse_position()
		elif Input.is_action_just_released("mouse_left") && is_grabbed:
			is_grabbed = false
			target.visible = false
			global_position = get_global_mouse_position()
			reset_timer()

func reset_timer() -> void:
	if timer && time_indicator:
		timer.stop()
		time_indicator.stop()
		if is_grabbed:
			global_position = get_global_mouse_position()
		if i == ouija_board.answer.length():
			i = 0
			timer.queue_free()
			time_indicator.queue_free()
			is_finished = true
			finish_timer.start()
		if i > 0 && ouija_board.answer[i - 1] == ouija_board.answer[i]:
			letters.get_node(ouija_board.answer[i]).is_double = true
		else:
			letters.get_node(ouija_board.answer[i]).is_double = false
		time_indicator.global_position = letters.get_node(ouija_board.answer[i]).global_position
		timer.start()
		time_indicator.play("timer")
		i += 1

func _on_timer_timeout() -> void:
	get_node("Collision").disabled = false
	reset_timer()

func _on_finish_timer_timeout() -> void:
	finish_timer.stop()
	if ouija_board.str == ouija_board.answer:
		ouija_board.minigame_finished.emit(true)
	else:
		print("FAILURE")
		ouija_board.minigame_finished.emit(false)

func _on_mouse_body_entered(body: Node2D) -> void:
	is_hovering = true


func _on_mouse_body_exited(body: Node2D) -> void:
	if !is_grabbed:
		is_hovering = false

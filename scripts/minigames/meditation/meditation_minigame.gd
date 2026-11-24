extends Node2D

@onready var spawn_location: PathFollow2D = $Path2D/SpawnLocation

@export var Thought: PackedScene
@export var SPAWN_NUMBER: int = 5

signal minigame_finished(success: bool)

var has_been_spawned: bool = false
var thoughts_count: int

func _ready() -> void:
	thoughts_count = SPAWN_NUMBER
	_spawn_thoughts()
	
func _spawn_thoughts() -> void:
	var thought_type: int 
	
	thought_type = randi_range(1, 3)
	thought_type = 1

	match thought_type:
		1:
			for i in SPAWN_NUMBER:
				_spawn_thought_1()
		2:
			for i in SPAWN_NUMBER:
				pass
		3:
			for i in SPAWN_NUMBER:
				pass
	for child in spawn_location.get_children():
		if child is RigidBody2D:
			child.connect("sig_i_died", Callable(self, "_count_thoughts"))
	has_been_spawned = true

func _count_thoughts():
	thoughts_count -= 1
	if thoughts_count <= 0:
		minigame_finished.emit(true)

func _spawn_thought_1() -> void:
	var thought:	RigidBody2D

	spawn_location.progress_ratio = randf()
	thought = Thought.instantiate()
	spawn_location.add_child(thought)
	_set_direction(thought, spawn_location)

func _set_direction(thought: RigidBody2D, spawn_pos: PathFollow2D) -> void:
	var direction 

	if spawn_pos.progress_ratio >= 0 and spawn_pos.progress_ratio < 0.2856:
		direction = spawn_pos.rotation + PI / 2
	elif spawn_pos.progress_ratio >= 0.2856 and spawn_pos.progress_ratio < 0.4997:
		direction = spawn_pos.rotation + PI
	elif spawn_pos.progress_ratio >= 0.4997 and spawn_pos.progress_ratio < 0.7853:
		direction = spawn_pos.rotation + (3 * PI / 2)
	elif spawn_pos.progress_ratio >= 0.7853 and spawn_pos.progress_ratio < 0.9994:
		direction = spawn_pos.rotation
		
	thought.position = spawn_pos.position
	direction += randf_range(-PI / 4, PI / 4)
	
	thought.linear_velocity = Vector2(randf_range(thought.min_speed, thought.max_speed), 0)
	thought.linear_velocity = thought.linear_velocity.rotated(direction)
	pass

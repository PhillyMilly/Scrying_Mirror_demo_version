extends Node2D

var drawing = false
var points = []
var drawn_points = []
var line_width = 5
var line_color = Color(0.819, 0.749, 0.690)

@onready var salt: AudioStreamPlayer = $Salt
@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D
@onready var delay_timer: Timer = $Timer
@onready var circle_indicator: AnimatedSprite2D = $"circle-indicator"
@onready var circle_indicator_timer: Timer = $CircleIndicatorTimer

signal minigame_finished(success: bool)

var min_point_distance = 5.0
var min_radius = 60.0
var distance_threshold = 20.0
var min_draw_time = 1.5
var draw_start_time = 0.0
var draw_delay = 0.01
var game_finished = false # ⬅️ Hier neu

func _ready():
	delay_timer.wait_time = draw_delay
	delay_timer.one_shot = false
	delay_timer.timeout.connect(_on_delay_timer_timeout)

	circle_indicator_timer.wait_time = 2.0
	circle_indicator_timer.one_shot = true
	circle_indicator_timer.timeout.connect(_on_circle_indicator_timeout)
	circle_indicator_timer.start()

func _input(event):
	if game_finished:
		return

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			drawing = event.pressed
			cpu_particles_2d.emitting = drawing

			if drawing:
				points = []
				drawn_points = []
				draw_start_time = Time.get_ticks_msec() / 1000.0
				delay_timer.start()

				# ▶️ Sound abspielen beim Start
				if not salt.playing:
					salt.play()
			else:
				var draw_duration = Time.get_ticks_msec() / 1000.0 - draw_start_time
				if draw_duration < min_draw_time:
					print("Der Kreis wurde zu schnell gezeichnet.")
					salt.stop() # ⏹️ Sound stoppen
					return

				drawing = false
				salt.stop() # ⏹️ Sound stoppen nach dem Zeichnen
	elif event is InputEventMouseMotion and drawing:
		var local_pos = get_local_mouse_position()
		cpu_particles_2d.global_position = get_global_mouse_position() + Vector2(0, -100)
		if points.is_empty() or points[-1].distance_to(local_pos) >= min_point_distance:
			points.append(local_pos)


func _on_delay_timer_timeout():
	if drawn_points.size() < points.size():
		drawn_points.append(points[drawn_points.size()])
		queue_redraw()
	elif not drawing:
		delay_timer.stop()
		check_circle()

func _on_circle_indicator_timeout():
	circle_indicator.visible = false

func _draw():
	if drawn_points.size() > 1:
		for i in range(drawn_points.size() - 1):
			draw_line(drawn_points[i], drawn_points[i + 1], line_color, line_width)

func check_circle():
	if points.size() < 50:
		print("Nicht genug Punkte gezeichnet.")
		return

	var center = Vector2()
	for p in points:
		center += p
	center /= points.size()

	var total_distance_variation = 0.0
	var previous_point_angle = 0.0
	var clockwise_sum = 0.0
	var total_radius = 0.0

	for i in range(points.size()):
		var p = points[i]
		var distance_to_center = p.distance_to(center)
		total_radius += distance_to_center
		total_distance_variation += abs(distance_to_center - points[0].distance_to(center))

		var angle = (p - center).angle()
		if i > 0:
			var angle_diff = angle - previous_point_angle
			if angle_diff > PI:
				angle_diff -= TAU
			elif angle_diff < -PI:
				angle_diff += TAU
			clockwise_sum += angle_diff

		previous_point_angle = angle

	var average_distance_variation = total_distance_variation / points.size()
	var average_radius = total_radius / points.size()
	var is_circular = average_distance_variation < distance_threshold
	var is_clockwise = clockwise_sum > 0
	var is_big_enough = average_radius >= min_radius

	if is_circular and is_clockwise and is_big_enough:
		print("Salzkreis erfolgreich gezogen!")
		game_finished = true # ⬅️ Kein weiteres Zeichnen möglich
		minigame_finished.emit(true)
	else:
		if not is_circular:
			print("Der Kreis ist nicht ringförmig genug.")
		if not is_clockwise:
			print("Der Kreis wurde nicht im Uhrzeigersinn gezogen.")
		if not is_big_enough:
			print("Der Kreis ist zu klein.")

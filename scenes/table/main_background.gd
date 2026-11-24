extends Node2D


@onready var sky_lightning: Sprite2D = $LightningAnimations/SkyLightning
@onready var table_lighting: Sprite2D = $LightningAnimations/TableLighting
@onready var alma_lightning: AnimatedSprite2D = $LightningAnimations/AlmaLightning
@onready var animate_lightning: AnimationPlayer = $LightningAnimations/AnimateLightning
@onready var lightning_timer: Timer = $LightningAnimations/LightningTimer


@export_category("Lighting Activation Percentage")
@export_range(0, 100, 1) var activation:            int = 20

func _ready() -> void:
	sky_lightning.visible = false
	table_lighting.visible = false
	

func _on_lightning_timer_timeout() -> void:
	var n:    int

	n = randi_range(0, 100)
	if n <= activation:
		lightning_timer.stop()
		n = randi_range(1, 3)
		match n:
			1:
				animate_lightning.play("lightning")
				await get_tree().create_timer(1.1).timeout
			2:
				animate_lightning.play("lightning2")
				await get_tree().create_timer(0.5).timeout
			3:
				animate_lightning.play("lightning3")
				await get_tree().create_timer(3).timeout
		lightning_timer.start()

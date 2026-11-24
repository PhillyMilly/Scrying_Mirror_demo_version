extends Node

@onready var no_contact: AudioStreamPlayer = $no_contact
@onready var contact: AudioStreamPlayer = $contact

func _on_job_manager_sig_lost_contact() -> void:
	contact.volume_db = -80
	no_contact.volume_db = 0

func _on_job_manager_sig_gained_contact(first_contact: bool) -> void:
	contact.volume_db = 0
	no_contact.volume_db = -80 

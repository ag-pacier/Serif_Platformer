extends Control

@onready var speaker_label = $PanelContainer/VBoxContainer/Speaker
@onready var current_dialog = null
@onready var pending_next: bool = false

func set_speaker(speaker: StringName):
	if speaker.length() > 20 or speaker.length() <= 0:
		speaker_label.text("Some Person")
	else:
		speaker_label.text(speaker)

extends Control

@onready var speaker_label = $PanelContainer/VBoxContainer/Speaker
@onready var speech = $PanelContainer/VBoxContainer/Speech
@onready var char_timer = $CharTimer
@onready var short_pause: float = 0.008
@onready var pause: float = 0.09
@onready var long_pause: float = 0.4
@onready var long_pause_chars: Array = [",", ".", "\n", "!", "?"]
@onready var short_pause_chars: Array = [" ", "'"]
@onready var cur_char: int = 0
@onready var next_char = 'A'
@onready var cur_dialog: String
@onready var display_finished: bool = true

func set_speaker(speaker: StringName) -> void:
	if speaker.length() > 20 or speaker.length() <= 0:
		speaker_label.text("Some Person")
	else:
		speaker_label.text(speaker)

func set_cur_dialog(dia: String) -> void:
	speech.visible_ratio = 0.0
	display_finished = false
	speech.text = dia
	cur_dialog = dia
	cur_char = 0
	speech.visible_characters = 1
	char_timer.start(short_pause)

func _on_char_timer_timeout() -> void:
	speech.visible_characters += 1
	if speech.visible_ratio < 1.0:
		cur_char = speech.visible_characters
		next_char = cur_dialog[cur_char]
		if next_char in short_pause_chars:
			char_timer.start(short_pause)
		elif next_char in long_pause_chars:
			char_timer.start(long_pause)
		elif next_char == cur_dialog[cur_char - 1]:
			char_timer.start(short_pause * 4)
		else:
			char_timer.start(pause)
	else:
		display_finished = true

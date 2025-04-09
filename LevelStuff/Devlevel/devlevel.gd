extends LevelBase

@onready var mood_test = preload("res://Sprites/MoodBubble/MoodBubble.tscn")

func _ready():
	super()


func _on_trigger_base_trigger_trip(_bod) -> void:
	var new_mood = mood_test.instantiate()
	add_child(new_mood)
	new_mood.global_position = $Items/Sign/TriggerBase.global_position
	new_mood.emote(0, true)

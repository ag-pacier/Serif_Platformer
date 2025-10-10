extends AnimatedSprite2D
class_name KitKit

# Mood sprite
@onready var mood_bub = preload("res://Sprites/MoodBubble/MoodBubble.tscn")

func show_mood(mood: int) -> void:
	if mood < 0 or mood > 8:
		print("Invalid mood indicator for Kitkit!")
		return
	var new_mood = mood_bub.instantiate()
	$EmoteAnchor.add_child(new_mood)
	new_mood.emote(mood, true)

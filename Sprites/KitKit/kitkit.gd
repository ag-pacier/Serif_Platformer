extends StaticBody2D
class_name KitKit

## Sleeping on spawn
@export var sleeping: bool = false

# Mood sprite
@onready var mood_bub = preload("res://Sprites/MoodBubble/MoodBubble.tscn")

# If Satrio is nearby
@onready var satrio_near: bool

func _ready() -> void:
	if sleeping:
		toggle_z(true)
		$AnimatedSprite2D.animation.play("asleep")
	else:
		toggle_z(false)
		$AnimatedSprite2D.animation.play("sitblank")
		

func toggle_z(active: bool) -> void:
	$EmoteAnchor/Zzs.emitting = active

func show_mood(mood: int) -> void:
	if mood < 0 or mood > 8:
		print("Invalid mood indicator for Kitkit!")
		return
	var new_mood = mood_bub.instantiate()
	$EmoteAnchor.add_child(new_mood)
	new_mood.emote(mood, true)


func _on_nearby_region_body_entered(body: Node2D) -> void:
	if body.is_in_group("MainC"):
		satrio_near = true


func _on_nearby_region_body_exited(body: Node2D) -> void:
	if body.is_in_group("MainC"):
		satrio_near = false


func _on_animated_sprite_2d_animation_finished() -> void:
	pass # Replace with function body.

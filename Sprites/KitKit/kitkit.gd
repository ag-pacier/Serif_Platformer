extends StaticBody2D
class_name KitKit

## Sleeping on spawn
@export var sleeping: bool = false

## If the cat is trying to be found via purring
@export var find_me: bool = false

# Mood sprite
@onready var mood_bub = preload("res://Sprites/MoodBubble/MoodBubble.tscn")

# If Satrio is nearby
@onready var satrio_near: bool

@onready var disap: bool = false

enum kitstate {
	ASLEEP = 0,
	BORED = 1,
	GUIDE = 2,
}

# Container for state
@onready var kitkit_state: kitstate

func _ready() -> void:
	if sleeping:
		toggle_z(true)
		$AnimatedSprite2D.animation.play("asleep")
		kitkit_state = kitstate.ASLEEP
	else:
		toggle_z(false)
		$AnimatedSprite2D.animation.play("sitblank")
		kitkit_state = kitstate.BORED
	if find_me:
		$purrcator.play()
	else:
		$FindSpot/CollisionShape2D.disabled = true

func _process(delta: float) -> void:
	if disap:
		var cur_alpha = $AnimatedSprite2D.self_modulate
		cur_alpha = (1, 1, 1, ())

func transition_state(new_state: kitstate):
	pass

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
		if find_me and not $purrcator.is_playing():
			disap = true


func _on_find_spot_body_entered(body: Node2D) -> void:
	if body.is_in_group("MainC"):
		$"meow-pick".play()
		$FindSpot/CollisionShape2D.set_deferred("disabled", true)
		$purrcator.stop()

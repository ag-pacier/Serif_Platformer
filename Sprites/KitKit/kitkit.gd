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

# If disappearing
@onready var disap: bool = false
@onready var ftrack: float = 1.0

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
		$AnimatedSprite2D.play("asleep")
		kitkit_state = kitstate.ASLEEP
	else:
		toggle_z(false)
		$AnimatedSprite2D.play("sitblank")
		kitkit_state = kitstate.BORED
	if find_me:
		$purrcator.play()
	else:
		$FindSpot/CollisionShape2D.disabled = true

func _process(delta: float) -> void:
	if disap:
		$AnimatedSprite2D.self_modulate = Color(1, 1, 1, ftrack)
		ftrack -= 4 * delta
		if ftrack < 0.1:
			queue_free()

func toggle_z(active: bool) -> void:
	$AnimatedSprite2D/EmoteAnchor/Zzs.emitting = active

func show_mood(mood: int) -> void:
	if mood < 0 or mood > 8:
		print("Invalid mood indicator for Kitkit!")
		return
	var new_mood = mood_bub.instantiate()
	$AnimatedSprite2D/EmoteAnchor.add_child(new_mood)
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
		toggle_z(false)
		$"meow-pick".play()
		$AnimatedSprite2D.play("backstretch")
		$FindSpot/CollisionShape2D.set_deferred("disabled", true)
		$purrcator.stop()
		show_mood(2)
		body.add_score(100)


func _on_purrcator_finished() -> void:
	if find_me and $FindSpot/CollisionShape2D.disabled == false:
		$purrcator.play()


func _on_animated_sprite_2d_animation_finished() -> void:
	var prev_anim = $AnimatedSprite2D.get_animation()
	match prev_anim:
		"backstretch":
			$AnimatedSprite2D.play("clean")
		_:
			var rng_choice = randi_range(0,1)
			if rng_choice == 0:
				$AnimatedSprite2D.play("sitblank")
			else:
				$AnimatedSprite2D.play("sitsidelook")

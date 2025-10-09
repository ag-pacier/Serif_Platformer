extends Node2D
class_name Door

@export var poof_unlock: bool = false
@export var key_unlock: bool

@onready var fade_away = false
@onready var fade_track = 1.0

func _ready() -> void:
	if $StaticBody2D/Open.texture == null:
		poof_unlock = true

func _process(delta: float) -> void:
	if fade_away:
		$StaticBody2D/Default.self_modulate = Color(1, 1, 1, fade_track)
		fade_track -= 5 * delta
		

func unlock_door() -> void:
	$OpenDoorSound.play()
	fade_away = true
	$StaticBody2D/CollisionShape2D.set_deferred("disabled", true)
	if !poof_unlock:
		$StaticBody2D/Default.set_deferred("visible", false)
		$StaticBody2D/Open.set_deferred("visible", true)



func _on_open_door_sound_finished() -> void:
	if poof_unlock:
		queue_free()

extends Node2D
class_name Door

@export var poof_unlock: bool = false
@export var key_unlock: bool

func _ready() -> void:
	if $StaticBody2D/Open.texture == null:
		poof_unlock = true

func unlock_door() -> void:
	$OpenDoorSound.play()
	$StaticBody2D/CollisionShape2D.set_deferred("disabled", true)
	if !poof_unlock:
		$StaticBody2D/Default.set_deferred("visible", false)
		$StaticBody2D/Open.set_deferred("visible", true)


func _on_open_door_sound_finished() -> void:
	if poof_unlock:
		queue_free()

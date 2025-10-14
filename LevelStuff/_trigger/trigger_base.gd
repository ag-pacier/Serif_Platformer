extends Area2D
class_name TriggerArea

## Name for trigger
@export var trigger_name: String = ""

## If the trigger should be disabled after being triggered
@export var one_time: bool = false

## Whether this item is a space for Satrio to do a contextual action
@export var contextual: bool = false

#Signal to send on trigger
signal trigger

func _ready() -> void:
	if contextual:
		set_collision_mask_value(7, false)
		if trigger_name == "":
			push_error("Triggers for context need a name!")

func _on_trigger(body: Node2D) -> void:
	if contextual:
		body.toggle_context(true, trigger_name)
	else:
		if one_time:
			$CollisionShape2D.set_deferred("disabled", true)
		emit_signal("trigger", trigger_name)

func _on_body_exited(body: Node2D) -> void:
	if contextual:
		body.toggle_context(false, "")

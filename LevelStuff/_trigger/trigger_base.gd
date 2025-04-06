extends Area2D
class_name TriggerArea

@export var trigger_name: String

# signal to emit when triggered
signal trigger_trip

func _ready():
	if trigger_name == "" or trigger_name == null:
		push_error("Trigger area has no name and will be disabled: ", get_path())
	else:
		$CollisionShape2D.set_deferred("disabled", false)


func _on_body_entered(body):
	emit_signal("trigger_trip", body, trigger_name)

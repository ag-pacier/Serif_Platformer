extends Area2D
class_name TriggerArea

@export var expected_body_group: String

func _ready():
	if expected_body_group == "" or expected_body_group == null:
		push_error("Trigger area has no expected body group and will be disabled: ", get_path())
	else:
		$CollisionShape2D.set_deferred("disabled", false)


func _on_body_entered(body):
	if body.is_in_group(expected_body_group):
		pass

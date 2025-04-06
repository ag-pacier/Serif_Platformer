extends Area2D
class_name TriggerArea

# signal to emit when triggered
signal trigger_trip

func _ready():
	$CollisionShape2D.set_deferred("disabled", false)


func _on_body_entered(body):
	emit_signal("trigger_trip", body)

extends Area2D
class_name FallReturn

## Where to head back to when falling in (Use global coords)
@export var return_point: Vector2

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("MainC"):
		body.zip_to(return_point)

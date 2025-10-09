extends Pickup
class_name Key

@export var key_color: Color

func _ready() -> void:
	super()
	$AnimatedSprite2D.self_modulate = key_color

func _on_body_entered(body):
	if body.is_in_group("MainC"):
		body.add_key_aura(pickup_name, key_color)
		super(body)

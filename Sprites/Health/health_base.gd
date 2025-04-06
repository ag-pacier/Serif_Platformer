extends Pickup
class_name Health

@export var heal_amount: int = 1
var heal_label: String

func _ready():
	if pickup_name == null:
		pickup_name = "HealthItem" + str(get_rid())
	worth = 5
	if heal_amount > 0:
		heal_label = "[color=green]+" + str(heal_amount) + "[/color]"
		$AnimatedSprite2D.play("good")
	else:
		heal_label = "[color=red]" + str(heal_amount) + "[/color]"
		$AnimatedSprite2D.play("bad")
	$HealLabel.parse_bbcode(heal_label)
	$SignificantParticles.visible = false
	super()

func _physics_process(delta):
	super(delta)
	if $HealLabel.visible == true:
		$HealLabel.position.y -= 25 * delta
		$HealLabel.scale -= Vector2(0.5, 0.5) * delta

func _on_body_entered(body):
	super(body)
	$HealLabel.visible = true
	if body.is_in_group("MainC"):
		body.change_health(heal_amount)

# When the pickup particles disappear then we can get rid of the object
func _on_pickup_particles_finished():
	queue_free()

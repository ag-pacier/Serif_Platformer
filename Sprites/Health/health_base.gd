extends Pickup
class_name Health

@export var heal_amount: int = 1

func _ready():
	super()
	if pickup_name == null:
		pickup_name = "HealthItem" + str(get_rid())
	worth = 5
	$SignificantParticles.visible = false

func _physics_process(delta):
	if $HealLabel.visible == true:
		$HealLabel.position.y -= 25 * delta
		$HealLabel.scale -= Vector2(0.5, 0.5) * delta

func _on_body_entered(body):
	var heal_label: String
	if heal_amount > 0:
		heal_label = "[color=green]+" + str(heal_amount) + "[/color]"
	else:
		heal_label = "[color=red]" + str(heal_amount) + "[/color]"
	$HealLabel.parse_bbcode(heal_label)
	super(body)
	$HealLabel.visible = true
	

# When the pickup particles disappear then we can get rid of the object
func _on_pickup_particles_finished():
	queue_free()

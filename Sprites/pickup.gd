extends Area2D
class_name Pickup

# Name of the pickup in case it needs to be referenced
@export var pickup_name: String
# How much the pickup gives the score
@export var worth: int = 0
# Sound played when the item is picked up
@export var pickup_sound: AudioStream
# Whether or not it should have *special glow*
@export var significant: bool = false

# Container if this will be displaying worth on pickup
var is_worthy: bool = false

# Signal to emit if a significant item is picked up
signal sig_pickup

func _ready():
	if $AnimatedSprite2D.sprite_frames == null:
		push_error("Pickup ", get_rid(), " does not have a SpriteFrames asscociated with it!")
	else:
		$AnimatedSprite2D.play()
	if significant:
		$SignificantParticles.visible = true
		# If the name wasn't set for a significant item, freak out
		if pickup_name == null:
			push_error("Pickup with significant marker not labeled and will ruin pickup trigger!")
	if pickup_sound != null:
		$PickupNoise.stream = pickup_sound

func _physics_process(delta):
	if is_worthy:
		$WorthLabel.position.y -= 15 * delta

# the main character is interacting with the pickup if their body enters this object
func _on_body_entered(body):
	if body.is_in_group("MainC"):
		# Play whatever noise is set to PickupNoise,
		# notify that it has been picked up and make the sprite invisible
		$PickupNoise.play()
		body.add_score(worth)
		# Set effects that happen after this point to render above EVERYTHING
		z_index = RenderingServer.CANVAS_ITEM_Z_MAX
		$AnimatedSprite2D.visible = false
		# Disable monitoring as this will object disappears after the particles are done
		set_deferred("monitoring", false)
		if significant:
			# If marked as significant, turn off the significant particles
			$SignificantParticles.emitting = false
			emit_signal("sig_pickup", pickup_name)
			
		elif worth != 0:
			var worth_string: String
			if worth < 0:
				worth_string = "-" + str(worth)
			else:
				worth_string = str(worth)
			$WorthLabel.parse_bbcode(worth_string)
			is_worthy = true
			$WorthLabel.visible = true
		# emit the pickup particles
		$PickupParticles.emitting = true

# When the pickup particles disappear then we can get rid of the object
func _on_pickup_particles_finished():
	queue_free()

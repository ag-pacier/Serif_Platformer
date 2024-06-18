extends Area2D
class_name Pickup

@export var pickup_name: String
@export var pickup_sound: AudioStream
@export var significant: bool = false

signal pickup_taken(pickup_name)

func _ready():
	if $AnimatedSprite2D.sprite_frames == null:
		push_error("Pickup ", get_rid(), " does not have a SpriteFrames asscociated with it!")
	else:
		$AnimatedSprite2D.play("default")
	if significant:
		$SignificantParticles.visible = true
	if pickup_sound != null:
		$PickupNoise.stream = pickup_sound

# the main character is interacting with the pickup if their body enters this object
func _on_body_entered(body):
	if body.is_in_group("MainC"):
		# Play whatever noise is set to PickupNoise,
		# notify that it has been picked up and make the sprite invisible
		$PickupNoise.play()
		pickup_taken.emit(pickup_name)
		$AnimatedSprite2D.visible = false
		if significant:
			# If marked as significant, turn off the significant particles
			$SignificantParticles.emitting = false
		# emit the pickup particles
		$PickupParticles.emitting = true

# When the pickup particles disappear then we can get rid of the object
func _on_pickup_particles_finished():
	queue_free()

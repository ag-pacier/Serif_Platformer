extends CharacterBody2D

const SPEED = 400.0
const JUMP_VELOCITY = -500.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Sprite animation node
@onready var anim_node: AnimatedSprite2D = get_node("AnimatedSprite2D")

# Jump sound player
@onready var jump_noise: AudioStreamPlayer = get_node("JumpSound")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor() and velocity.y < 800:
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump_noise.play()
		anim_node.play("jump")
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	# Set direction based on velocity
	if velocity.x >= 0:
		anim_node.scale.x = 1
	else:
		anim_node.scale.x = -1
	# make sure there is always some animation playing
	if is_on_floor():
		if velocity.x == 0:
			anim_node.play("default")
		else:
			anim_node.play("move")
	else:
		if velocity.y >= 0:
			anim_node.play("fall")
		else:
			anim_node.play("jump")
	move_and_slide()


func _on_animated_sprite_2d_animation_finished():
	if velocity.y > 0:
		anim_node.play("fall")
	if is_on_floor():
		if velocity.x == 0:
			anim_node.play("default")
		else:
			anim_node.play("move")
		

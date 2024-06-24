extends CharacterBody2D

const SPEED = 400.0
const JUMP_VELOCITY = -500.0

# Enum for emoting
enum Emotion {
	SPEECHLESS = 0,
	SHOCK = 1,
	CONTENT = 2,
	JOY = 3,
	STUNNED = 4,
	NORMAL = 5,
	SIGH = 6,
	SAD = 7,
	MAD = 8
}

# Scale and position for emote to start with
@onready var start_scale = 0.1
@onready var start_pos = Vector2(0, -20)

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Sprite animation node
@onready var anim_node: AnimatedSprite2D = get_node("AnimatedSprite2D")

# Timer for briefly limiting movement during bounces and injuries
@onready var bounce_timer: Timer = get_node("BounceTimer")

@onready var emote_sprite: AnimatedSprite2D = get_node("Emote")

func _ready():
	# Set max health and score
	$Hud.set_max_health(3)
	$Hud.set_health(3)
	$Hud.set_score(0)

## Publicly accessible method to ensure the HUD gets the message to change the
## score
func add_score(added_score: int):
	$Hud.increment_score(added_score)

func trigger_action():
	emote(Emotion.CONTENT)

## Publicly accessible method to elicit emotion from Satrio
func emote(emotion: Emotion):
	if emotion < Emotion.SPEECHLESS or emotion > Emotion.MAD:
		emotion = Emotion.SPEECHLESS
	emote_sprite.frame = emotion
	emote_sprite.scale = Vector2(start_scale, start_scale)
	emote_sprite.position = start_pos
	emote_sprite.visible = true
	$EmoteTimer.start()

## method to control behavior of emote while visible. Uses the delta of the
## process method it's called in
func _emoting_now(delta):
	# Don't bother if the sprite is invisible
	if emote_sprite.visible == false:
		return
	if emote_sprite.scale < Vector2(1, 1):
		emote_sprite.scale += Vector2(.1, .1)
		emote_sprite.position.y += 50 * delta
	elif emote_sprite.position.y >= -30:
		emote_sprite.position.y -= 10 * delta


func _physics_process(delta):
	# Make the DebugSprite invisible
	$DebugSprite.visible = false
	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("left", "right")
	if bounce_timer.is_stopped():
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, (SPEED / 8))
		
	# Add the gravity with terminal velocity
	# Modify velocity if we are "wall sliding"
	if not is_on_floor():
		if is_on_wall() and velocity.y > -10 and direction != 0:
			# In case we hit are able to latch onto a wall after falling a while
			# check the velocity and quarter it until we are under a sliding speed
			if velocity.y > 100:
				velocity.y = velocity.y * .25
		if velocity.y < 800:
			velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and (is_on_floor() or is_on_wall()):
		$JumpSound.play()
		anim_node.play("jump")
		velocity.y = JUMP_VELOCITY
		if is_on_wall_only():
			velocity.x = -50 * anim_node.scale.x
			bounce_timer.start()
		
	# Set direction based on velocity
	if velocity.x >= 0:
		anim_node.scale.x = 1
	else:
		anim_node.scale.x = -1
	# make sure there is always some animation playing
	# play appropriate sounds for movement
	if is_on_floor():
		if velocity.x == 0:
			anim_node.play("default")
		else:
			anim_node.play("move")
			if $StepSounds.is_playing() == false:
				$StepSounds.play()
	else:
		if velocity.y >= 0:
			if is_on_wall() and direction != 0:
				anim_node.play("dodge_stop")
			else:
				anim_node.play("fall")
		else:
			anim_node.play("jump")
	move_and_slide()
	_emoting_now(delta)

## When an animation finishes, check to see what we should be doing and
## ensure animation continues as it should
func _on_animated_sprite_2d_animation_finished():
	if velocity.y > 0:
		anim_node.play("fall")
	if is_on_floor():
		if velocity.x == 0:
			anim_node.play("default")
		else:
			anim_node.play("move")

## When the step sound finishes, if we are still moving, play it again
func _on_step_sounds_finished():
	if anim_node.animation == "move":
		$StepSounds.play()


## When the emote timer elapses, make the emote icon invisible
func _on_emote_timer_timeout():
	print("Emote timer timed out")
	if emote_sprite.visible == true:
		emote_sprite.visible = false
		emote_sprite.scale = Vector2(start_scale, start_scale)
		emote_sprite.position = start_pos

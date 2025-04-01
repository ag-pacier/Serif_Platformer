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

# Timer for briefly limiting movement during bounces and injury
@onready var bounce_timer: Timer = get_node("BounceTimer")

# Timer for briefly preventing additional damage during injury
@onready var hurt_timer: Timer = get_node("InjuryTimer")

# Node that controls the emote for Satrio
@onready var emote_sprite: AnimatedSprite2D = get_node("Emote")

# container for the V of HSV when Satrio gets hurt
@onready var color_v: float = 0

# container for if Satrio is alive
@onready var alive: bool = true
signal not_alive

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
	change_health(-1)

## Publicly accessible method to elicit emotion from Satrio
func emote(emotion: Emotion):
	if emotion < Emotion.SPEECHLESS or emotion > Emotion.MAD:
		emotion = Emotion.SPEECHLESS
	emote_sprite.frame = emotion
	emote_sprite.scale = Vector2(start_scale, start_scale)
	emote_sprite.position = start_pos
	emote_sprite.visible = true
	$EmoteTimer.start()

## Publicly accessible method to change Satrio's health
## negative health will be considered an injury
## positive health with be considered a heal
func change_health(health: int):
	# If we forgot to indicate a number or its zero, do nothing
	if health == 0 or health == null:
		return
	elif health < 0:
		# If the health amount is negative, start the timers
		# and set the animation indicators
		$InjuryTimer.start()
		bounce_timer.start()
		anim_node.play("on_hit")
		anim_node.self_modulate = Color.from_hsv(0, 100, 0)
		velocity.y = -80
		velocity.x = -30 * anim_node.scale.x
		color_v = 0
	$Hud.increment_health(health)

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
	# Deal with the emotion if it is showing
	_emoting_now(delta)
	# If the injury timer is running, tweak the V of the HSV
	if not $InjuryTimer.is_stopped():
		var new_alpha = randf_range(0.1, 0.8)
		color_v += 2.0
		anim_node.self_modulate = Color.from_hsv(0, 100, color_v, new_alpha)
	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("left", "right")
	if bounce_timer.is_stopped() and alive:
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, (SPEED / 8))
		
	# Add the gravity with terminal velocity
	# Modify velocity if we are "wall sliding"
	if not is_on_floor() and alive:
		if is_on_wall() and velocity.y > -10 and direction != 0:
			# In case we hit are able to latch onto a wall after falling a while
			# check the velocity and quarter it until we are under a sliding speed
			if velocity.y > 100:
				velocity.y = velocity.y * .25
		if velocity.y < 800:
			velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and (is_on_floor() or is_on_wall()) and alive:
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
	if alive and not anim_node.animation == "on_hit":
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

## When an animation finishes, check to see what we should be doing and
## ensure animation continues as it should
func _on_animated_sprite_2d_animation_finished():
	if alive:
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
	if emote_sprite.visible == true:
		emote_sprite.visible = false
		emote_sprite.scale = Vector2(start_scale, start_scale)
		emote_sprite.position = start_pos

## When the injury timer elapses, we can be hurt again :(
func _on_injury_timer_timeout():
	anim_node.self_modulate = Color(1, 1, 1, 1)
	color_v = 0

func _on_death():
	alive = false
	emit_signal("not_alive")
	$InjuryTimer.stop()
	anim_node.self_modulate = Color(1, 1, 1, 1)
	velocity = Vector2(0,0)
	anim_node.play("game_over")

extends CharacterBody2D

const SPEED = 400.0
const JUMP_VELOCITY = -500.0

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

# Mood sprite
@onready var mood_bub = preload("res://Sprites/MoodBubble/MoodBubble.tscn")

# Container for key auras
@onready var held_keys: Dictionary

# container for the V of HSV when Satrio gets hurt
@onready var color_v: float = 0

# container for if Satrio is alive
@onready var alive: bool = true
signal not_alive

# container if Satrio has a context-relevant action they can do
@onready var context_act: bool = false
@onready var context_item: StringName = ""
## Let a trigger know you are acting
signal context_sig

# container if Satrio has dialog interactions they can do
@onready var dialog_act: bool = false
@onready var speaker: String = ""
@onready var speak: String = ""
@onready var source_trigger: DialogTrigger

# container for dash related vars
@onready var dashing: bool = false

func _ready():
	# Set max health and score
	$Hud.set_max_health(3)
	$Hud.set_health(3)
	$Hud.set_score(0)
	$Hud.hud_dialog_complete.connect(_dialog_done)

## Publicly accessible method to ensure the HUD gets the message to change the
## score
func add_score(added_score: int):
	$Hud.increment_score(added_score)


func bounce_me(back: bool = false) -> void:
	velocity.y = -200.0
	if back:
		velocity.x = -250.0 * anim_node.scale.x
	bounce_timer.start()


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
		if $InjuryTimer.is_stopped():
			$InjuryTimer.start()
			bounce_me(true)
			anim_node.play("on_hit")
			anim_node.self_modulate = Color.from_hsv(0, 100, 0)
			color_v = 0
		else:
			# If injury timer is running and we got a negative health change,
			# ignore it (haha, invincible)
			return
	$Hud.increment_health(health)

## Move Satrio to a given location globally in the shared scene he is in
func zip_to(new_loc: Vector2):
	self.global_position = new_loc

func force_talking(speaks: String, speakin: String) -> void:
	$Hud.start_dialog(speaks, speakin)

func action_task() -> void:
	if context_act:
		emit_signal("context_sig", context_item)
	elif dialog_act:
		$Hud.start_dialog(speaker, speak)
	else:
		if $DashCooldown.is_stopped():
			dashing = true
			$DashSound.play()
			if velocity.x > -1:
				velocity = Vector2(1200, 0)
			else:
				velocity = Vector2(-1200, 0)
			$DashTimer.start(0.2)
			$DashCooldown.start(2.5)
			anim_node.play("swoosh")
			$AnimatedSprite2D/Zap.visible = true
			$AnimatedSprite2D/Zap.play()

## Publicly accessible method to configure context from triggers
func toggle_context(con_ready: bool, con_name: StringName) -> void:
	context_act = con_ready
	$DebugSprite.visible = con_ready
	context_item = con_name

func set_dtrigger(TrigSource: DialogTrigger) -> void:
	source_trigger = TrigSource

func clear_dtrigger() -> void:
	source_trigger = null

func _dialog_done() -> void:
	if not source_trigger == null:
		source_trigger.queue_free()
		self.clear_dtrigger()

## Publicly accessible method to configure dialog when available
func toggle_dialog(diag_ready: bool, ready_speaker: String, spoken: String) -> void:
	$DebugSprite.visible = diag_ready
	dialog_act = diag_ready
	speaker = ready_speaker
	speak = spoken

func _physics_process(delta):
	# Check what we are touching and trip injury if the damage layer
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider() == null:
			continue
		if collision.get_collider().name == "Damage" and alive:
			var found_angle = collision.get_angle()
			if $InjuryTimer.is_stopped() and (found_angle < 1 or found_angle > 3):
				change_health(-1)
			break
	# If the injury timer is running, tweak the V of the HSV
	if not $InjuryTimer.is_stopped():
		var new_alpha = randf_range(0.1, 0.8)
		color_v += 2.0
		anim_node.self_modulate = Color.from_hsv(0, 100, color_v, new_alpha)
	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("left", "right")
	if bounce_timer.is_stopped() and alive and not dashing:
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, (SPEED / 2))
		
	# Add the gravity with terminal velocity
	# Modify velocity if we are "wall sliding"
	if not is_on_floor() and alive and not dashing:
		if is_on_wall() and velocity.y > -10 and direction != 0:
			# In case we hit are able to latch onto a wall after falling a while
			# check the velocity and quarter it until we are under a sliding speed
			if velocity.y > 100:
				velocity.y = velocity.y * .25
		if velocity.y < 800:
			velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and (is_on_floor() or is_on_wall()) and alive and not dashing:
		$JumpSound.play()
		anim_node.play("jump")
		velocity.y = JUMP_VELOCITY
		if is_on_wall_only():
			velocity.x = -50 * anim_node.scale.x
			bounce_timer.start()
		
	if Input.is_action_just_pressed("action") and alive and not dashing:
		action_task()
		
	# Set direction based on velocity
	if velocity.x >= 0:
		anim_node.scale.x = 1
	else:
		anim_node.scale.x = -1
	# make sure there is always some animation playing
	# play appropriate sounds for movement
	if alive and not anim_node.animation == "on_hit" and not dashing:
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
		else:
			if velocity.x == 0:
				anim_node.play("default")
			else:
				anim_node.play("move")
	else:
		$AnimatedSprite2D.visible = false

## When the step sound finishes, if we are still moving, play it again
func _on_step_sounds_finished():
	if anim_node.animation == "move":
		$StepSounds.play()

func has_key(aurname: StringName) -> bool:
	if aurname in held_keys:
		return true
	return false

func add_key_aura(aurname: StringName, col: Color) -> void:
	if aurname not in held_keys:
		held_keys[aurname] = col

func remove_key_aura(aurname: StringName) -> void:
	if aurname in held_keys:
		held_keys.erase(aurname)

## When the injury timer elapses, we can be hurt again :(
func _on_injury_timer_timeout():
	anim_node.self_modulate = Color(1, 1, 1, 1)
	color_v = 0

func _on_death():
	alive = false
	emit_signal("not_alive")
	$CollisionShape2D.set_deferred("disabled", true)
	$InjuryTimer.stop()
	anim_node.self_modulate = Color(1, 1, 1, 1)
	velocity = Vector2(0,0)
	anim_node.play("game_over")


func _on_dash_timer_timeout() -> void:
	dashing = false
	anim_node.play()
	$AnimatedSprite2D/Sweat.emitting = true


func _on_zap_animation_finished() -> void:
	$AnimatedSprite2D/Zap.visible = false


func _on_dash_cooldown_timeout() -> void:
	$DashReady.play()
	$AnimatedSprite2D/Sweat.emitting = false

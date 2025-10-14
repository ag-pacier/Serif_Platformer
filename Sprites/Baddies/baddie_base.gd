extends CharacterBody2D
class_name Enemy

## Maximum health that this baddie can obtain
@export var max_health: int = 1
## Maximum speed the baddie can move
@export var speed: int = 500
## Weather the baddie can fly
@export var flying: bool = false
## Toggle ability to pick up items (aka THIEF)
@export var pickup_items: bool = false
## Toggle desire to go beast mode on the main character
@export var aggro: bool = false
## How often to check the vision for things
@export var react_time: float = 0.5
## Starting behavior
@export var default_behavior: behave = behave.ASLEEP
## See nothing counter
@export var time_to_default: int = 5
@onready var nothing_check: int = 0
## Attack Frame
@export var attack_frm: int

@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var last_seen
@onready var current_health: int = max_health
@onready var current_feel: behave = default_behavior
@onready var emote_spot = $AnimatedSprite2D/EmoteAnchor
@onready var mood_bub = preload("res://Sprites/MoodBubble/MoodBubble.tscn")
@onready var poof = preload("res://Sprites/Baddies/poof_out.tscn")
@onready var ani_node = $AnimatedSprite2D
@onready var color_v: float = 0
@onready var default_aggro: bool = aggro
@onready var mainc_loc
@onready var attacking
@onready var moving: bool = true
@onready var start_x: float

enum behave {
	ASLEEP = 0,
	SHOCK = 1,
	HAPPY = 2,
	JOY = 3,
	BLANK = 4,
	SAD = 5,
	ANGRY = 6
}

signal enemy_gone

func _ready() -> void:
	$VisualTimer.wait_time = react_time
	if ani_node.sprite_frames == null:
		push_error("No sprite frames to be found, enemy will need to be removed! Object:", self.to_string())
	else:
		ani_node.play("default")

func _physics_process(delta: float) -> void:
	# If startx hasn't been grabbed yet, try to. Don't let it be origin
	if start_x == null or start_x == 0.0:
		start_x = global_position.x
	# If the injury timer is running, tweak the V of the HSV
	if not $InjuryTimer.is_stopped():
		var new_alpha = randf_range(0.1, 0.8)
		color_v += 0.9
		ani_node.self_modulate = Color.from_hsv(0, 1, color_v, new_alpha)
	if attacking != null and current_feel == behave.ANGRY:
		if $AnimatedSprite2D.animation != "attack":
			$AnimatedSprite2D.play("attack")
		elif $AnimatedSprite2D.frame == attack_frm:
			attacking.change_health(-1)
	# Set movement if needed
	if moving:
		if mainc_loc != null:
			var main_dir = global_position.x - mainc_loc.x
			if main_dir > 1:
				main_dir = -1
			else:
				main_dir = 1
			if attacking == null:
				velocity.x = move_toward(velocity.x, main_dir * speed, speed)
			elif $AnimatedSprite2D.animation != "attack":
				velocity.x = move_toward(velocity.x, 0, speed)
			else:
				velocity.x = 0
				if flying:
					velocity.y = 0
		else:
			var main_dir = global_position.x - start_x
			if main_dir > 10:
				main_dir = -1
			elif main_dir < -10:
				main_dir = 1
			else:
				main_dir = 0
			if main_dir != 0:
				velocity.x = move_toward(velocity.x, main_dir * speed, speed)
			else:
				velocity.x = move_toward(velocity.x, 0, speed)
	else:
		velocity.x = 0
		if flying:
			velocity.y = 0
	# Face towards the likely way that main character is coming from
	# unless it makes sense to look elsewhere
	if velocity.x > 0:
		$AnimatedSprite2D.scale.x = -1
		$VisionCast.target_position.x = 100
	else:
		$AnimatedSprite2D.scale.x = 1
		$VisionCast.target_position.x = -100
	
	
	# Make gravity happen
	if not flying and not is_on_floor():
		if velocity.y < 600:
			velocity.y += gravity * delta
	move_and_slide()


## Create mood bubble based on current feel
func mood_indicate(mood: behave = current_feel) -> void:
	var new_mood = mood_bub.instantiate()
	$AnimatedSprite2D/EmoteAnchor.add_child(new_mood)
	match mood:
		behave.ASLEEP:
			new_mood.emote(6, true)
		behave.SHOCK:
			new_mood.emote(1, true)
		behave.HAPPY:
			new_mood.emote(2, true)
		behave.JOY:
			new_mood.emote(3, true)
		behave.BLANK:
			new_mood.emote(4, true)
		behave.SAD:
			new_mood.emote(7, true)
		behave.ANGRY:
			new_mood.emote(8, true)
		_:
			push_error("Baddie asked to indicate invalid mood:", current_feel)


## On poof_out, we animate the indicator that the enemy is going away
## If score or a drop is going to be done, it should be done here
func poof_out() -> void:
	var cloud_ani = poof.instantiate()
	add_child(cloud_ani)
	cloud_ani.play()
	emit_signal("enemy_gone")
	cloud_ani.animation_finished.connect(_cleanup)

func behavior_transition(new_behave: behave) -> void:
	match current_feel:
		behave.ASLEEP:
			$AnimatedSprite2D/EmoteAnchor/Zs.emitting = false
		behave.SHOCK:
			pass
		behave.HAPPY:
			pass
		behave.JOY:
			pass
		behave.BLANK:
			pass
		behave.SAD:
			pass
		behave.ANGRY:
			pass
		_:
			pass
		
	match new_behave:
		behave.ASLEEP:
			$AnimatedSprite2D/EmoteAnchor/Zs.emitting = true
		behave.SHOCK:
			mood_indicate(behave.SHOCK)
			$BehaveTimer.start(1.0)
			if moving:
				moving = false
		behave.HAPPY:
			if !moving:
				moving = true
		behave.JOY:
			mood_indicate(behave.JOY)
			$BehaveTimer.start(2.0)
		behave.BLANK:
			mood_indicate(behave.BLANK)
			$BehaveTimer.start(2.0)
			if moving:
				moving = false
		behave.SAD:
			mood_indicate(behave.SAD)
			$BehaveTimer.start(2.0)
			if moving:
				moving = false
		behave.ANGRY:
			mood_indicate(behave.ANGRY)
			$BehaveTimer.start(1.0)
			if !moving:
				moving = true
		_:
			pass
		
	current_feel = new_behave

## On reaction time, check to see if we see anything and react to it
func _on_visual_timer_timeout() -> void:
	if $VisionCast.is_colliding():
		var coll_body = $VisionCast.get_collider()
		if coll_body.is_in_group("MainC"):
			mainc_loc = coll_body.position
			if last_seen == null and nothing_check == 0:
				behavior_transition(behave.SHOCK)
			else:
				if current_feel != behave.ANGRY and aggro:
					behavior_transition(behave.ANGRY)
					nothing_check = 1
		last_seen = coll_body
	else:
		if last_seen != null:
			last_seen = null
			behavior_transition(behave.BLANK)
		if nothing_check >= 1:
			if nothing_check < time_to_default:
				nothing_check += 1
			else:
				nothing_check = 0
		else:
			mainc_loc = null
		


func _on_injury_timer_timeout() -> void:
	ani_node.self_modulate = Color(1, 1, 1, 1)
	color_v = 0
	if default_aggro:
		aggro = true


func _on_behave_timer_timeout() -> void:
	if current_feel != default_behavior and last_seen == null:
		behavior_transition(default_behavior)


func _cleanup() -> void:
	queue_free()


func _on_animated_sprite_2d_animation_finished() -> void:
	match $AnimatedSprite2D.animation:
		"default":
			$AnimatedSprite2D.play("default")
		"attack":
			$AnimatedSprite2D.play("default")
		"dead":
			poof_out()
		_:
			push_warning("Animation ", $AnimatedSprite2D.animation, " finished but doesn't have a case!")
	


func _on_hit_box_body_entered(body: Node2D) -> void:
	var hit_angle = body.get_angle_to(position)
	if hit_angle > 0.8 and hit_angle < 2.5 and body.is_in_group("MainC"):
		body.bounce_me(true)
		if $InjuryTimer.is_stopped():
			aggro = false
			if current_health <= 1:
				velocity = Vector2.ZERO
				flying = true
				$VisionCast.enabled = false
				ani_node.play("dead")
				$HitBox/CollisionShape2D.set_deferred("disabled", true)
			else:
				current_health -= 1
				behavior_transition(behave.SAD)
				$InjuryTimer.start()
	else:
		body.change_health(-1)


func _on_attack_box_entered(body: Node2D) -> void:
	if body.is_in_group("MainC"):
		attacking = body

func _on_attack_box_exited(body: Node2D) -> void:
	if body.is_in_group("MainC"):
		attacking = null

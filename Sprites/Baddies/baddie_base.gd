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

@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var last_seen
@onready var current_health: int = max_health
@onready var current_feel: behave = default_behavior
@onready var emote_spot = $AnimatedSprite2D/EmoteAnchor
@onready var mood_bub = preload("res://Sprites/MoodBubble/MoodBubble.tscn")
@onready var poof = preload("res://Sprites/Baddies/poof_out.tscn")
@onready var ani_node = $AnimatedSprite2D

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
		behave.HAPPY:
			pass
		behave.JOY:
			mood_indicate(behave.SHOCK)
			$BehaveTimer.start(2.0)
		behave.BLANK:
			mood_indicate(behave.BLANK)
			$BehaveTimer.start(2.0)
		behave.SAD:
			mood_indicate(behave.SAD)
			$BehaveTimer.start(2.0)
		behave.ANGRY:
			mood_indicate(behave.ANGRY)
			$BehaveTimer.start(1.0)
		_:
			pass
		
	current_feel = new_behave

## On reaction time, check to see if we see anything and react to it
func _on_visual_timer_timeout() -> void:
	if $VisionCast.is_colliding():
		var coll_body = $VisionCast.get_collider()
		last_seen = coll_body
		#print(last_seen)
	else:
		last_seen = null


func _on_injury_timer_timeout() -> void:
	pass # Replace with function body.


func _on_behave_timer_timeout() -> void:
	pass # Replace with function body.


func _cleanup() -> void:
	queue_free()


func _on_animated_sprite_2d_animation_finished() -> void:
	match $AnimatedSprite2D.animation:
		"default":
			$AnimatedSprite2D.play("default")
		"attack":
			pass
		"dead":
			poof_out()
		_:
			push_warning("Animation ", $AnimatedSprite2D.animation, " finished but doesn't have a case!")
	


func _on_hit_box_body_entered(body: Node2D) -> void:
	var hit_angle = body.get_angle_to(position)
	if hit_angle > 0.8 and hit_angle < 2.5:
		body.bounce_me(false)
		if $InjuryTimer.is_stopped():
			if current_health <= 1:
				flying = true
				aggro = false
				$VisionCast.enabled = false
				ani_node.play("dead")
				$CollisionShape2D.set_deferred("disabled", true)
				$HitBox/CollisionShape2D.set_deferred("disabled", true)
			else:
				current_health -= 1
				behavior_transition(behave.SAD)
				$InjuryTimer.start()
	else:
		body.change_health(-1)

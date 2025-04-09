extends Node2D
class_name MoodBubble

enum mood {
	SPEECHLESS = 0,
	SHOCK = 1,
	CONTENT = 2,
	HAPPY = 3,
	HM = 4,
	FINE = 5,
	SIGH = 6,
	SAD = 7,
	ANGRY = 8
}

@onready var spr = $Sprite
@onready var init_pop = true

func _ready() -> void:
	spr.visible = false
	spr.scale = Vector2(0.0001, 0.0001)

## Create a mood using mood enum, second arg is if it should be temporary
func emote(emomood: mood, temp_emo: bool = true):
	spr.frame = emomood
	spr.visible = true
	if temp_emo:
		$Lifetime.start()

func _physics_process(_delta: float) -> void:
	if spr.visible:
		if init_pop:
			if spr.scale < Vector2(1.8, 1.8):
				spr.scale = spr.scale * 1.5
			else:
				init_pop = false
				$AudioStreamPlayer2D.play()
		else:
			if spr.scale > Vector2(1.1, 1.1):
				spr.scale = spr.scale * 0.8
			

## If a lifetime timer was started, delete it at the end
func _on_lifetime_timeout() -> void:
	queue_free()

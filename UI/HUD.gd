extends CanvasLayer

# Containers for displayed and pending change items
@onready var _current_health: int = 0
@onready var _current_score: int = 0
@onready var buffer_health: int = 0
@onready var buffer_score: int = 0

# Nodes for displaying items in HUD
@onready var health_display = get_node("TopContainer/HealthText")
@onready var score_display = get_node("TopContainer/ScoreText")

func _process(_delta):
	if not buffer_health == 0:
		if $HealthIncTimer.is_stopped():
			if buffer_health > 0:
				_current_health += 1
				buffer_health -= 1
			else:
				_current_health -= 1
				buffer_health += 1
			health_display.clear()
			health_display.parse_bbcode("Health: " + str(_current_health))
			$HealthIncTimer.start()
	if not buffer_score == 0:
		if buffer_score > 0:
			_current_score += 1
			buffer_score -= 1
		else:
			_current_score -= 1
			buffer_score += 1
		score_display.clear()
		score_display.parse_bbcode("Score: " + str(_current_score))


func increment_score(increment: int):
	buffer_score += increment

func increment_health(increment: int):
	buffer_health += increment

func set_health(health: int):
	_current_health = health
	health_display.clear()
	health_display.parse_bbcode("Health: " + str(_current_health))

func set_score(score: int):
	_current_score = score
	score_display.clear()
	score_display.parse_bbcode("Score: " + str(_current_score))

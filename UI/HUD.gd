extends CanvasLayer

# Containers for displayed and pending change items
@onready var _current_health: int = 0
@onready var _current_score: int = 0
@onready var buffer_health: int = 0
@onready var buffer_score: int = 0

# Maximum health container
@onready var _max_health: int = 3

# Nodes for displaying items in HUD
@onready var health_display = get_node("TopContainer/HealthText")
@onready var score_display = get_node("TopContainer/ScoreText")

# Indicator that Satrio has reached 0 health :(
signal death

func _process(_delta):
	# Only do any checking if the buffer has health in it
	if not buffer_health == 0:
		# Everytime the health increment timer stops, move the buffer
		# closer to zero and reflect the change in the health
		if $HealthIncTimer.is_stopped():
			if buffer_health > 0:
				# only add to the health if under the max
				if _current_health < _max_health:
					_current_health += 1
				buffer_health -= 1
			else:
				_current_health -= 1
				buffer_health += 1
			health_display.clear()
			health_display.parse_bbcode("Health: " + str(_current_health))
			if _current_health <= 0:
				_on_zero_health()
			$HealthIncTimer.start()
	if not buffer_score == 0:
		# If the buffer isn't zero, plink up or down on the current score
		# every process frame until the buffer is back to zero
		# update the display for the score everytime it changes
		if buffer_score > 0:
			_current_score += 1
			buffer_score -= 1
		else:
			_current_score -= 1
			buffer_score += 1
		score_display.clear()
		score_display.parse_bbcode("Score: " + str(_current_score))

## increment the score up (using positive numbers) or down (using negative numbers)
## note that the increment goes into a buffer that slowly builds into the score
## which allows rapid changes back and forth to be smoothed out
func increment_score(increment: int):
	buffer_score += increment

## increment the health up and down using integers. This uses a buffer to smooth
## out rapid changes in health and also give players a chance to snatch victory
## from defeat in critical situations
func increment_health(increment: int):
	buffer_health += increment

## Set health without increment. Will also update the display. Primarily used on
## level start or save load
func set_health(health: int):
	_current_health = health
	health_display.clear()
	health_display.parse_bbcode("Health: " + str(_current_health))

## Set score without increment. Will also update the display. Primarily used on
## level start or save load
func set_score(score: int):
	_current_score = score
	score_display.clear()
	score_display.parse_bbcode("Score: " + str(_current_score))

## Set the max health so that the HUD can track when to top out
## This purposefully does not touch nor invalid the health buffer
func set_max_health(max_health: int):
	if max_health > 3:
		_max_health = max_health
	else:
		_max_health = 3

func _on_zero_health():
	buffer_health = 0
	emit_signal("death")
	$CenterContainer.visible = true

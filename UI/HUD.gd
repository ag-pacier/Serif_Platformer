extends CanvasLayer

# Containers for displayed and pending change items
@onready var _current_health: int = 0
@onready var _current_score: int = 0
@onready var buffer_health: int = 0
@onready var buffer_score: int = 0

# Maximum health container
@onready var _max_health: int = 3

# Nodes for displaying items in HUD
@onready var score_display = get_node("TopContainer/ScoreText")

# Container for health indicators
@onready var hearts: Array
@onready var health_sprite = preload("res://UI/HealthIndi/healthtexture.tscn")

# Indicator that Satrio has reached 0 health :(
signal death

func _ready() -> void:
	generate_health_indicator()

## Update the health bar if max health has changed
func generate_health_indicator():
	# Fill the hearts array until it matches what the max health
	while len(hearts) < _max_health:
		# create a heart sprite and place it based on it's part of
		# the array
		var new_heart = health_sprite.instantiate()
		#var new_x: float = (len(hearts) * 16) + 8
		var new_index = len(hearts) + 1
		#new_heart.position = Vector2(new_x, 0)
		$TopContainer.add_child(new_heart)
		$TopContainer.move_child(new_heart, new_index)
		hearts.push_back(new_heart)
	# If the max_health is lower than the hearts showing up,
	# get rid of extra hearts until we are back to what we need
	while len(hearts) > _max_health:
		var bad_heart = hearts.pop_back()
		bad_heart.queue_free()

## Update the health bar if health changes
func update_health_indicator():
	var cur_heart = 0
	for heart in hearts:
		if cur_heart < _current_health:
			heart.healed()
		else:
			heart.hurt()
		cur_heart += 1

func _process(_delta):
	# Only do any checking if the buffer has health in it and the game's not
	# paused
	if not buffer_health == 0 and get_tree().paused == false:
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
			#health_display.clear()
			#health_display.parse_bbcode("Health: " + str(_current_health))
			update_health_indicator()
			if _current_health <= 0:
				_on_zero_health()
			$HealthIncTimer.start()
	# If the buffer isn't zero, plink up or down on the current score
	# every process frame until the buffer is back to zero
	# update the display for the score everytime it changes
	if not buffer_score == 0 and get_tree().paused == false:
		if buffer_score > 0:
			_current_score += 1
			buffer_score -= 1
		else:
			_current_score -= 1
			buffer_score += 1
		score_display.clear()
		score_display.parse_bbcode("Score: " + str(_current_score))
	
	# Handle pausing the game
	# Using a pause timer to prevent rapid pausing
	if Input.is_action_just_pressed("pause") and $PauseTimer.is_stopped():
		$PauseTimer.start()
		if get_tree().paused:
			$CenterContainer/MenuContainer.visible = false
			get_tree().paused = false
		else:
			get_tree().paused = true
			$CenterContainer/MenuContainer.visible = true

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
	generate_health_indicator()
	update_health_indicator()

## Set score without increment. Will also update the display. Primarily used on
## level start or save load
func set_score(score: int):
	_current_score = score
	score_display.clear()
	score_display.parse_bbcode("Score: " + str(_current_score))

## Set the max health so that the HUD can track when to top out
## This purposefully does not touch nor invalid the health buffer
func set_max_health(max_health: int):
	if max_health > _max_health:
		_max_health = max_health
		generate_health_indicator()

func _on_zero_health():
	buffer_health = 0
	emit_signal("death")
	$CenterContainer/GmOva.visible = true

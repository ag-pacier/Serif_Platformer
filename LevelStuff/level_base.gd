extends Node
class_name LevelBase

## Level Base script
##
## This script should be used as a basis for all other levels. These will have
## ways to subscribe to triggers, ensure Satrio available and alive among other
## actions

@onready var background_music: AudioStreamPlayer = get_node("BackgroundMusic")
@onready var satrio: CharacterBody2D = get_node("Satrio")

func _ready():
	# Check if the background music is exists and push errors if something is amiss
	# or set the appropriate settings if it is where it needs to be
	if background_music == null:
		push_error("Unable to find expected background music node at BackgroundMusic as a AudioStreamPlayer")
	elif background_music.stream == null:
		push_error("Node found but no stream set")
	else:
		background_music.volume_db = -6
		background_music.autoplay = true
		background_music.bus = "Music"

	# Check if Satrio is present and listen for the signals related
	if satrio == null:
		push_error("Unable to find expected character as a CharacterBody2D named Satrio")
	else:
		get_node("Satrio/Hud").death.connect(_on_death)

func _on_death():
	background_music.stop()

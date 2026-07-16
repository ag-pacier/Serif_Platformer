extends Area2D
class_name DialogTrigger

## Who will be speaking
@export var speaker: String

## What they will say
@export var spoke: String

## If they can say it again
@export var repeatable: bool = false

func _ready() -> void:
	if speaker == "" or spoke == "":
		push_error("No empty name or dialog allowed for these triggers!")

func _in_range(body: Node2D) -> void:
	body.toggle_dialg

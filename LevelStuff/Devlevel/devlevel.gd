extends LevelBase

func _ready():
	super()

func _satrio_context(context: StringName) -> void:
	print("Passed to dev level: ", context)
	match context:
		"WrongWay":
			print("We made it, champ")
		_:
			print("Made it to dev level but didn't recognize the context")

func _on_slime_enemy_gone() -> void:
	var new_slime = preload("res://Sprites/Baddies/Slime/Slime.tscn").instantiate()
	$Enemies.add_child(new_slime)
	new_slime.position = Vector2(693.0, 218.0)
	new_slime.enemy_gone.connect(_on_slime_enemy_gone)

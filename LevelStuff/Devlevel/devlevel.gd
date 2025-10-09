extends LevelBase

@onready var test_door = $Doors/Door

func _ready():
	super()
	


func _on_trigger_base_trigger_trip(bod) -> void:
	if bod.is_in_group("MainC") and test_door != null and bod.has_key("RedKey"):
		test_door.unlock_door()


func _on_slime_enemy_gone() -> void:
	var new_slime = preload("res://Sprites/Baddies/Slime/Slime.tscn").instantiate()
	$Enemies.add_child(new_slime)
	new_slime.position = Vector2(693.0, 218.0)
	new_slime.enemy_gone.connect(_on_slime_enemy_gone)

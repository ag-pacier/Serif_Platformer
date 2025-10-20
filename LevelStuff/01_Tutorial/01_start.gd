extends LevelBase

func _ready():
	super()
	$Doors/StartTest/RInput.set_icon("right", "keyboard")

func _satrio_context(context: StringName) -> void:
	super(context)


func _on_start_test_trigger() -> void:
	if $StartTimer.is_stopped():
		$Doors/StartTest/RInput.set_deferred("visible", false)
	else:
		$StartTimer.stop()


func _on_start_timer_timeout() -> void:
	$Doors/StartTest/RInput.set_deferred("visible", true)

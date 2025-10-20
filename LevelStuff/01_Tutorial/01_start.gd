extends LevelBase

func _ready():
	super()
	$Doors/StartTest/RInput.set_icon("right", "keyboard")
	$Doors/LeftSymbol/LInput.set_icon("left", "keyboard")

func _satrio_context(context: StringName) -> void:
	super(context)


func _on_start_test_trigger() -> void:
	if $StartTimer.is_stopped():
		$Doors/StartTest/RInput.set_deferred("visible", false)
	else:
		$StartTimer.stop()


func _on_start_timer_timeout() -> void:
	$Doors/StartTest/RInput.set_deferred("visible", true)


func _on_left_symbol_trigger() -> void:
	if $Doors/LeftSymbol/LInput.visible:
		$Doors/LeftSymbol/LInput.set_deferred("visible", false)
	else:
		$LeftTimer.stop()


func _on_left_symbol_start_trigger() -> void:
	$LeftTimer.start()


func _on_left_timer_timeout() -> void:
	$Doors/LeftSymbol/LInput.set_deferred("visible", true)


func _on_jump_symbol_trigger() -> void:
	print("Jump symbol tripped but not made yet")


func _on_jump_done_trigger() -> void:
	print("Jump symbol turned off!")

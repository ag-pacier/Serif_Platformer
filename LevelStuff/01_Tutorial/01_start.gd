extends LevelBase

func _ready():
	super()
	$Doors/StartTest/RInput.set_icon("right", "keyboard")
	$Doors/LeftSymbol/LInput.set_icon("left", "keyboard")
	$Doors/JumpSymbol/JumpInput.set_icon("jump", "keyboard")
	var _kitten_guide = preload("res://Sprites/KitKit/kitkit.tscn")

func _satrio_context(context: StringName) -> void:
	super(context)


func _on_start_test_trigger() -> void:
	print("Start trigger hit")
	if $StartTimer.is_stopped():
		$Doors/StartTest/RInput.toggle_visible(false)
	else:
		print("Cancelling start timer")
		$StartTimer.stop()


func _on_start_timer_timeout() -> void:
	print("Start timer finished!")
	$Doors/StartTest/RInput.toggle_visible(true)


func _on_left_symbol_trigger() -> void:
	print("Touched left symbol!")
	if $Doors/LeftSymbol/LInput.visible:
		$Doors/LeftSymbol/LInput.toggle_visible(false)
	else:
		$LeftTimer.stop()


func _on_left_symbol_start_trigger() -> void:
	print("Timer started to show the left movement symbol")
	$LeftTimer.start()


func _on_left_timer_timeout() -> void:
	print("Left symbol timer finished!")
	$Doors/LeftSymbol/LInput.toggle_visible(true)


func _on_jump_symbol_trigger() -> void:
	print("Jump symbol tripped")
	$Doors/JumpSymbol/JumpInput.toggle_visible(true)


func _on_jump_done_trigger() -> void:
	print("Jump symbol turned off!")
	$Doors/JumpSymbol/JumpInput.toggle_visible(false)


func _on_kit_kit_kitty_signal(signal_name: Variant) -> void:
	if signal_name == "first":
		$Satrio.force_talking("Talking Cat??", "Startled me! Press the action button to close this dialog box.")
	elif signal_name == "second":
		$Satrio.force_talking("Talking Cat?!", "Feels weird to share the space with another. I'm Kit.")
	elif signal_name == "third":
		$Satrio.force_talking("Kit", "You got a name? How'd you get here anyway?")
	elif signal_name == "fourth":
		$Satrio.force_talking("Kit", "If you said something, I couldn't hear it. You seem capable enough otherwise. Keep following, I want to show you something.")
	elif signal_name == "fifth":
		$Satrio.force_talking("Kit", "You're pretty quick! I bet clicking the action button when not talking lets you dash. Not a bad trick to know.")

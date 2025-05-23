extends Control

@onready var cur_menu = $VBoxContainer/SubMen/TopMenu

func _process(_delta: float) -> void:
	if Input.is_action_just_released("down_dir"):
		var _action = cur_menu.next_item()
	if Input.is_action_just_released("up_dir"):
		var _action = cur_menu.prev_item()
	if Input.is_action_just_released("return_but"):
		cur_menu.act_item()


func _on_top_menu_menu_change(item: String) -> void:
	match item:
		"Settings":
			cur_menu.visible = false
			cur_menu = $VBoxContainer/SubMen/setmen
			cur_menu.visible = true
		"Exit":
			$QuitTimer.start()
		_:
			print("Saw: ", item)


func _on_quit_timer_timeout() -> void:
	get_tree().quit()


func _on_set_menu_menu_change(item: String) -> void:
		match item:
			"Back":
				cur_menu.visible = false
				cur_menu = $VBoxContainer/SubMen/TopMenu
				cur_menu.visible = true
			_:
				print("Saw: ", item)

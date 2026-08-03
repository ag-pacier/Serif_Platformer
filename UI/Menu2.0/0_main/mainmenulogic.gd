extends CenterContainer

@onready var current_menu: MenuI = $Prime/TopLevel
@onready var menu_lst: Dictionary = {"Main": $Prime/TopLevel, "Level Select": $Prime/LvlSelect, "Settings": $Prime/Settings}

func _on_top_level_selected_item(ite: String) -> void:
	if ite == "Start":
		get_tree().change_scene_to_file("res://LevelStuff/01_Tutorial/01start.tscn")
	elif ite == "Level Select" or ite == "Settings":
		_switch_menu(ite)
	elif ite == "Exit":
		get_tree().quit()
	else:
		push_error("Received invalid entry in Main Menu of:", ite)

func _switch_menu(new_menu: String) -> void:
	if not menu_lst.has(new_menu):
		push_error("Menu option not available. Saw:", new_menu)
		return
	current_menu.visible = false
	current_menu = menu_lst.get(new_menu)
	current_menu.visible = true


func _on_lvl_select_selected_item(ite: String) -> void:
	if ite == "Developer Arena":
		get_tree().change_scene_to_file("res://LevelStuff/Devlevel/devLevel.tscn")
	elif ite == "Tutorial":
		get_tree().change_scene_to_file("res://LevelStuff/01_Tutorial/01start.tscn")
	elif ite == "Back To Main":
		_switch_menu("Main")
	else:
		push_error("Received invalid entry in Level Menu of:", ite)

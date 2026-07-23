extends Control

# Current menu
@onready var cur_menu: StringName = "Main"

# Possible Menus
@onready var menus: Array = ["Main", "Settings", "Load Game"]

# Current Selection
@onready var selection: int = 0
@onready var max_select: int = 0

func _activate_menu(menu: StringName) -> void:
	if not menu in menus:
		push_error("Bad menu activation for: ", menu)
		return
	elif menu == cur_menu:
		return
	
	selection = 0
	cur_menu = menu
	$Primary/Main/Title.text = menu
	if menu == "Main":
		max_select = 4
	elif menu == "Settings":
		max_select = 3

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("down_dir"):
		if selection == max_select:
			selection = 0
		else:
			selection += 1
	elif Input.is_action_just_pressed("up_dir"):
		if selection == 0:
			selection = max_select
		else:
			selection -= 1
	elif Input.is_action_just_pressed("return_but"):
		activate_item(cur_menu, selection)

func activate_item(men: StringName, sel: int) -> void:
	if men == "Main":
		if sel == 0:
			# Start a new game!
			pass
		elif sel == 1:
			_activate_menu("Load Game")
		elif sel == 2:
			_activate_menu("Settings")
		elif sel == 3:
			_activate_menu("Level Select")
		elif sel == 4:
			get_tree().quit()
		else:
			push_error("Given bad selection of: ", selection)
	elif men == "Settings":
		if sel == 0:
			_activate_menu("Sounds")
		elif sel == 1:
			_activate_menu("Video")
		elif sel == 2:
			_activate_menu("Controls")
		elif sel == 3:
			_activate_menu("Main")
		else:
			push_error("Given bad selection of: ", selection)
	elif men == "Load Game":
		pass
	elif men == "Level Select":
		pass
	elif men == "Sounds":
		pass
	elif men == "Video":
		pass
	elif men == "Controls":
		pass
	else:
		push_error("Unanticipated menu submitted: ", men)

extends Control

@onready var current_item: int = 0
@onready var max_item: int = 0
@onready var men_label = $VBoxContainer/VBoxContainer/MenuLabel
@onready var main = $VBoxContainer/VBoxContainer/Main
@onready var sets = $VBoxContainer/VBoxContainer/Settings
@onready var current_menu = $VBoxContainer/VBoxContainer/Main
@onready var active_item_effect = preload("res://UI/cur_item_effect.tres")

func _ready():
	reset_menus()

## Select a menu item
func select_item(item: int):
	var action = current_menu.get_child(item).text
	match action:
		"Back":
			move_menu(0)
		"EXIT":
			$QuitTimer.start()
		"Settings":
			move_menu(1)
		_:
			print("Not implemented yet:", action)

func reset_menus():
	var old_item = current_menu.get_child(current_item)
	old_item.label_settings = null
	current_menu = main
	set_label("Main")
	main.visible = true
	sets.visible = false
	current_item = 0
	old_item = current_menu.get_child(current_item)
	old_item.label_settings = active_item_effect
	max_item = len(main.get_children())

func set_label(lab):
	men_label.clear()
	men_label.add_text(lab)

func move_menu(menu: int):
	match menu:
		0:
			reset_menus()
		1:
			set_label("Settings")
			main.visible = false
			sets.visible = true
			current_item = 0
			current_menu = sets
			
		_:
			push_error("Unknown menu provided for move_menu in Pause. Menu called:", menu)

func _process(_delta):
	if Input.is_action_just_pressed("up_dir") or Input.is_action_just_pressed("left"):
		if current_item > 0:
			var old_item = current_menu.get_child(current_item)
			old_item.label_settings = null
			current_item -= 1
			old_item = current_menu.get_child(current_item)
			old_item.label_settings = active_item_effect
	if Input.is_action_just_pressed("down_dir") or Input.is_action_just_pressed("right"):
		if current_item < max_item:
			var old_item = current_menu.get_child(current_item)
			old_item.label_settings = null
			current_item += 1
			old_item = current_menu.get_child(current_item)
			old_item.label_settings = active_item_effect
	if Input.is_action_just_pressed("return_but") or Input.is_action_just_pressed("action"):
		select_item(current_item)


func _on_quit_timer_timeout() -> void:
	get_tree().quit()

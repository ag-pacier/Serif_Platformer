extends Control

@onready var current_item: int = 0

## Select a menu item
func select_item(item: int):
	print(item)

func reset_cur_item():
	current_item = 0

func _process(_delta):
	if Input.is_action_just_pressed("up_dir") or Input.is_action_just_pressed("left"):
		current_item -= 1
	if Input.is_action_just_pressed("down_dir") or Input.is_action_just_pressed("right"):
		current_item += 1
	if Input.is_action_just_pressed("return_but") or Input.is_action_just_pressed("action"):
		select_item(current_item)

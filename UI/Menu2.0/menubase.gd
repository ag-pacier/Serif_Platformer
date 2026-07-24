extends VBoxContainer
class_name MenuI

## Top level indicator
@export var top_level_menu: bool

## Menu Name
@export var title: String

## Menu Options
@export var entries: Array[String]

# Menu Dictionary
@onready var menu_item_list: Dictionary

# Signal on menu action
signal activation(selection_name)

# Node to put entries
@onready var item_list: VBoxContainer = get_node("MTitle/ItemList")

# Current selection
@onready var current_selection: int = 0

# Current selection effect
@onready var current_effect = preload("res://UI/Menu2.0/cur_item_effect.tres")

func _ready() -> void:
	if title == "":
		push_error("Menu title not set!")
	else:
		$MTitle.text = title
	
	for entry in entries:
		var new_entry = Label.new()
		new_entry.text = entry
		item_list.add_child(new_entry)
		menu_item_list.set(entry, new_entry)
	
	var final_entry = Label.new()
	if top_level_menu:
		final_entry.text = "Exit"
		menu_item_list.set("Exit", final_entry)
	else:
		final_entry.text = "Prev"
		menu_item_list.set("Prev", final_entry)
	item_list.add_child(final_entry)
	

func move_ind(previous: bool = false) -> void:
	if previous:
		if current_selection == 0:
			current_selection = len(item_list)
		else:
			current_selection -= 1
	else:
		if current_selection == len(item_list):
			current_selection = 0
		else:
			current_selection += 1

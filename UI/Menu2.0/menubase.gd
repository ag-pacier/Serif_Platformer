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

func move_ind(previous: bool = false) -> void:
	var cur_item: Label = menu_item_list.get(entries[current_selection])
	cur_item.label_settings = null
	if previous:
		if current_selection == 0:
			current_selection = len(menu_item_list)
		else:
			current_selection -= 1
	else:
		if current_selection == len(menu_item_list):
			current_selection = 0
		else:
			current_selection += 1
	cur_item = menu_item_list.get(entries[current_selection])
	cur_item.label_settings = current_effect

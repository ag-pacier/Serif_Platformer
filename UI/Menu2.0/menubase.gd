extends VBoxContainer
class_name MenuI

# Type of selection represented in the entry
enum selection_type {
	BASIC = 0,
	SLIDER = 1
}

## Top level indicator
@export var top_level_menu: bool

## Menu Name
@export var title: String

## Menu Options
@export var entries: Array[String]

# Menu Dictionary
@onready var menu_item_list: Dictionary[String, Array]

# Node to put entries
@onready var item_list: VBoxContainer = get_node("ItemList")

# Current selection
@onready var current_selection: int = 0

# Current selection effect
@onready var current_effect = preload("res://UI/Menu2.0/cur_item_effect.tres")

# Signal to pass what is being selected
signal selected_item(ite: String)

func _ready() -> void:
	if title == "":
		push_error("Menu title not set!")
	else:
		$MTitle.text = title
	
	for entry in entries:
		var new_entry = Label.new()
		var entry_type = selection_type.BASIC
		new_entry.text = entry
		item_list.add_child(new_entry)
		menu_item_list.set(entry, [entry_type, new_entry])
	
	var first_item = menu_item_list.get(entries[0])
	if first_item[0] == selection_type.BASIC:
		first_item[1].label_settings = current_effect
	else:
		first_item[1].selected_slider(true)

func move_ind(previous: bool = false) -> void:
	var cur_item: Array = menu_item_list.get(entries[current_selection])
	if cur_item[0] == selection_type.BASIC:
		cur_item[1].label_settings = null
	else:
		cur_item[1].selected_slider(false)
	if previous:
		if current_selection == 0:
			current_selection = len(menu_item_list) - 1
		else:
			current_selection -= 1
	else:
		if current_selection == len(menu_item_list) - 1:
			current_selection = 0
		else:
			current_selection += 1
	cur_item = menu_item_list.get(entries[current_selection])
	if cur_item[0] == selection_type.BASIC:
		cur_item[1].label_settings = current_effect
	else:
		cur_item[1].selected_slider(true)

func activation() -> void:
	print("Activation for ", title, " on entry: ", entries[current_selection])
	selected_item.emit(entries[current_selection])

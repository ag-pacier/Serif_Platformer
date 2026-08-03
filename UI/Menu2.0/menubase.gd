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
@onready var item_list: VBoxContainer = get_node("ItemList")

# Current selection
@onready var current_selection: int = 0

# Current selection effect
@onready var current_effect = preload("res://UI/Menu2.0/cur_item_effect.tres")

# Input cooldown
@onready var inp_timer: Timer = $InputCool

# Signal to pass what is being selected
signal selected_item(ite: String)

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
	
	menu_item_list.get(entries[0]).label_settings = current_effect

func move_ind(previous: bool = false) -> void:
	var cur_item: Label = menu_item_list.get(entries[current_selection])
	cur_item.label_settings = null
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
	cur_item.label_settings = current_effect

func activation() -> void:
	print("Activation for ", title, " on entry: ", entries[current_selection])
	selected_item.emit(entries[current_selection])
	inp_timer.start()

func _process(_delta: float) -> void:
	if self.visible and inp_timer.is_stopped():
		if Input.is_action_just_pressed("down_dir"):
			move_ind()
		elif Input.is_action_just_pressed("up_dir"):
			move_ind(true)
		elif Input.is_action_just_pressed("return_but"):
			activation()

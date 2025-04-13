extends Control
class_name PauseMenuBase

signal menu_change

## Title of the menu that is being made
@export var menu_title: String
## Should the last item be "back" (false) or "exit" (true)
@export var top_menu: bool = false
## Array of all selectable items by reference to their label node
@onready var menu_items: Array = [$LastItem]
## menu item that should have the highlight on it
@onready var cur_item: int = 0
## Highlight style
@onready var hilite = preload("res://UI/PauseMenu/cur_item_effect.tres")

func _ready() -> void:
	if menu_title == "" or menu_title == null:
		menu_title = "Unnamed Menu"
	$MenuTitle.text = menu_title
	if top_menu:
		$LastItem.text = "Exit"
	else:
		$LastItem.text = "Back"
	menu_items[0].label_settings = hilite

## Rebuild the menu_items array. Will auto add the LastItem label
func rebuild_menu_items(new_items: Array) -> void:
	new_items.append_array([$LastItem])
	menu_items = new_items

## Proceed to the next available item in the menu
## Returns TRUE if there is something next and FALSE if its the end
func next_item() -> bool:
	if cur_item + 1 < len(menu_items):
		menu_items[cur_item].label_settings = null
		cur_item += 1
		menu_items[cur_item].label_settings = hilite
		return true
	else:
		return false

## Proceed to the previous available item in the menu
## Returns TRUE if there is something previously and FALSE if its the begining
func prev_item() -> bool:
	if cur_item > 0:
		menu_items[cur_item].label_settings = null
		cur_item -= 1
		menu_items[cur_item].label_settings = hilite
		return true
	else:
		return false

func act_item() -> void:
	emit_signal("menu_change", menu_items[cur_item].text)

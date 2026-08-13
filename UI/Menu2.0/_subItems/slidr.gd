extends HBoxContainer
class_name setSlider

## Name of slider
@export var slider_name: String

## Indicating name and value when changed
signal val_changed(sname: String, sval: int)

# Selected effect
@onready var select_effect: LabelSettings = preload("res://UI/Menu2.0/cur_item_effect.tres")

func _ready() -> void:
	if slider_name == "":
		push_error("Slider names cannot be blank")
	else:
		$NameLabel.text = slider_name

## Change value of slider by one increment
func inc_value(pos: bool) -> void:
	var cur_val: float = $HSlider.value
	if pos and cur_val < 100.0:
		cur_val += 5
		if cur_val > 100.0:
			cur_val = 100.0
	elif not pos and cur_val > 0.0:
		cur_val -= 5
		if cur_val < 0.0:
			cur_val = 0.0
	$HSlider.set_value_no_signal(cur_val)

## Set the value of the slider immediately
func set_slide_value(new_val: int) -> void:
	if new_val < 0 or new_val > 100:
		push_error("Unable to set slider ", slider_name, " to a value of ", new_val)
		return
	$HSlider.set_value_no_signal(new_val)
	val_changed.emit(slider_name, new_val)

func _on_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		val_changed.emit(slider_name, $HSlider.value)

func selected_slider(selected: bool) -> void:
	if selected:
		$NameLabel.label_settings = select_effect
	else:
		$NameLabel.label_settings = null

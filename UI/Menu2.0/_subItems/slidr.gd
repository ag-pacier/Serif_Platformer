extends HBoxContainer
class_name setSlider

## Name of slider
@export var slider_name: String

## Indicating name and value when changed
signal val_changed(sname: String, sval: int)

func _ready() -> void:
	if slider_name == "":
		push_error("Slider names cannot be blank")
	else:
		$NameLabel.text = slider_name

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

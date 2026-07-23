extends VBoxContainer
class_name MenuI

## Menu Name
@export var title: String

func _ready() -> void:
	if title == "":
		push_error("Menu title not set!")
	else:
		$MTitle.text = title

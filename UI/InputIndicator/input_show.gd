extends Node2D

enum act_put {
	RIGHT = 0,
	LEFT = 1,
	JUMP = 2,
	ACT = 3,
	PAUSE = 4,
}

enum ctrl_style {
	GEN_CONTROLLER = 0,
	KEYBOARD = 1,
}

@onready var img = $Sprite2D
## Dict for keyboard related controls to display
@onready var img_dict_keyb: Dictionary = {
	"right-arrow": "Right_key",
	"left-arrow": "Left_key",
	"space-bar": "null",
	"f-key": "F_key",
	"esc-key": "ESC",
}
## Dict for controller related controls to display
@onready var img_dict_ctrl: Dictionary = {
	"right": "Right_stick",
	"left": "Left_Stick",
	"jump": "RdB_button",
	"action": "GrnA_button",
	"pause": "Start",
}

func _ready() -> void:
	toggle_visible(false)

func toggle_visible(vis: bool = true):
	set_deferred("visible", vis)

func set_icon(new: StringName, c_style: StringName) -> void:
	var indicate: act_put
	var ind_style: ctrl_style
	match new.to_lower():
		"right":
			indicate = act_put.RIGHT
		"left":
			indicate = act_put.LEFT
		"jump":
			indicate = act_put.JUMP
		"pause":
			indicate = act_put.PAUSE
		_:
			indicate = act_put.ACT
	match c_style.to_lower():
		"keyboard":
			ind_style = ctrl_style.KEYBOARD
		_:
			ind_style = ctrl_style.GEN_CONTROLLER
	var new_item: String
	if ind_style == ctrl_style.KEYBOARD:
		match indicate:
			act_put.RIGHT:
				new_item = img_dict_keyb["right-arrow"]
			act_put.LEFT:
				new_item = img_dict_keyb["left-arrow"]
			act_put.JUMP:
				new_item = img_dict_keyb["space-bar"]
			act_put.ACT:
				new_item = img_dict_keyb["f-key"]
			act_put.PAUSE:
				new_item = img_dict_keyb["esc-key"]
			_:
				return
	else:
		match indicate:
			act_put.RIGHT:
				new_item = img_dict_ctrl["right"]
			act_put.LEFT:
				new_item = img_dict_ctrl["left"]
			act_put.JUMP:
				new_item = img_dict_ctrl["jump"]
			act_put.ACT:
				new_item = img_dict_ctrl["action"]
			act_put.PAUSE:
				new_item = img_dict_ctrl["pause"]
			_:
				return
	if indicate != act_put.JUMP:
		$SpaceBar.set_deferred("visible", false)
		img.set_deferred("visible", true)
		img.animation = new_item
		img.frame = 1
	else:
		img.set_deferred("visible", false)
		$SpaceBar.set_deferred("visible", true)
		

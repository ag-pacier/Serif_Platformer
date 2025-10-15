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
## keyboard key size (use twice for Rect2)
@onready var sq_sz: float = 16.0
## Dict for keyboard related controls to display
@onready var img_dict_keyb: Dictionary = {
	"right-arrow": Rect2(496.0, 192.0, sq_sz, sq_sz),
	"left-arrow": Rect2(528.0, 192.0, sq_sz, sq_sz),
	"space-bar": Rect2(496.0, 224.0, 48.0, sq_sz),
	"f-key": Rect2(336.0, 176.0, sq_sz, sq_sz),
	"esc-key": Rect2(272.0, 128.0, sq_sz, sq_sz),
}
## Dict for controller related controls to display
@onready var img_dict_ctrl: Dictionary = {
	"right": Rect2(160.0, 80.0, sq_sz, sq_sz),
	"left": Rect2(192.0, 80.0, sq_sz, sq_sz),
	"jump": Rect2(144.0, 16.0, sq_sz, sq_sz), # Dark B button
	"action": Rect2(128.0, 16.0, sq_sz, sq_sz), # Dark A button
	"pause": Rect2(304.0, 368.0, sq_sz, sq_sz), # Generic dark oval
}

## Current texture to show on the atlas
@onready var cur_item: Rect2 = img_dict_keyb["right-arrow"]

func set_icon(new: act_put, c_style: ctrl_style = ctrl_style.KEYBOARD) -> void:
	var new_item: Rect2
	if c_style == ctrl_style.KEYBOARD:
		match new:
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
		match new:
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
	cur_item = new_item
	_update_sprite()

func _update_sprite() -> void:
	img.region_rect = cur_item

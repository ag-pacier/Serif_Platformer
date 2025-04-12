extends PauseMenuBase

func _ready():
	rebuild_menu_items([$VBoxContainer/Settings])
	super()

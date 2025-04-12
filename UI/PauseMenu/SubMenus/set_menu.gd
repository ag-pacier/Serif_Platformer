extends PauseMenuBase

func _ready():
	rebuild_menu_items([$VBoxContainer/MasterVolume/MasterVolLab])
	super()

extends PauseMenuBase

func _ready():
	var new_menu_items = [$TopVolume/MasLabel,
						$EffectVolume/EffLabel,
						$MusicVolume/MusLabel]
	rebuild_menu_items(new_menu_items)
	$TopVolume/MasSlider.set_value_no_signal(AudioServer.get_bus_volume_db(0))
	$EffectVolume/EffSlider.set_value_no_signal(AudioServer.get_bus_volume_db(2))
	$MusicVolume/MusSlider.set_value_no_signal(AudioServer.get_bus_volume_db(1))
	super()

func _process(_delta: float):
	if Input.is_action_just_released("left"):
		var slider = null
		match cur_item:
			0:
				slider = $TopVolume/MasSlider
			1:
				slider = $EffectVolume/EffSlider
			2:
				slider = $MusicVolume/MusSlider
			_:
				slider = null
		if not slider == null:
			var cur_value = slider.value
			if cur_value > -80.0:
				slider.value = slider.value - 5.0
	if Input.is_action_just_released("right"):
		var slider = null
		match cur_item:
			0:
				slider = $TopVolume/MasSlider
			1:
				slider = $EffectVolume/EffSlider
			2:
				slider = $MusicVolume/MusSlider
			_:
				slider = null
		if not slider == null:
			var cur_value = slider.value
			if cur_value < 6.0:
				slider.value = slider.value + 5.0

func _on_mus_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		AudioServer.set_bus_volume_db(1, $MusicVolume/MusSlider.value)

func _on_eff_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		AudioServer.set_bus_volume_db(2, $EffectVolume/EffSlider.value)

func _on_mas_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		AudioServer.set_bus_volume_db(0, $TopVolume/MasSlider.value)

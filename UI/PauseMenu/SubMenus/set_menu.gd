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

func _on_mus_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		AudioServer.set_bus_volume_db(1, $MusicVolume/MusSlider.value)

func _on_eff_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		AudioServer.set_bus_volume_db(2, $EffectVolume/EffSlider.value)

func _on_mas_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		AudioServer.set_bus_volume_db(0, $TopVolume/MasSlider.value)

extends MenuI

func _ready() -> void:
	entries.append_array(["AudioMaster", "AudioEffects", "AudioMusic", "Back To Main"])
	menu_item_list.set("AudioMaster", [selection_type.SLIDER, $ItemList/AudioMaster])
	menu_item_list.set("AudioEffects", [selection_type.SLIDER, $ItemList/AudioEffects])
	menu_item_list.set("AudioMusic", [selection_type.SLIDER, $ItemList/AudioMusic])
	menu_item_list.set("Back To Main", [selection_type.BASIC, $ItemList/Back2Main])
	
	$ItemList/AudioMaster.set_slide_value(AudioServer.get_bus_volume_db(0))
	$ItemList/AudioEffects.set_slide_value(AudioServer.get_bus_volume_db(2))
	$ItemList/AudioMusic.set_slide_value(AudioServer.get_bus_volume_db(1))
	
	var first_item = menu_item_list.get(entries[0])
	if first_item[0] == selection_type.BASIC:
		first_item[1].label_settings = current_effect
	else:
		first_item[1].selected_slider(true)


func _on_audio_master_val_changed(_sname: String, sval: int) -> void:
	AudioServer.set_bus_volume_db(0, sval)

func _on_audio_effects_val_changed(_sname: String, sval: int) -> void:
	AudioServer.set_bus_volume_db(2, sval)

func _on_audio_music_val_changed(_sname: String, sval: int) -> void:
	AudioServer.set_bus_volume_db(1, sval)

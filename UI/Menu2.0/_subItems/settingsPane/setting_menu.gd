extends MenuI

func _ready() -> void:
	entries.append_array(["AudioMaster", "AudioEffects", "AudioMusic", "Back To Main"])
	menu_item_list.set("AudioMaster", [selection_type.SLIDER, $ItemList/AudioMaster])
	menu_item_list.set("AudioEffects", [selection_type.SLIDER, $ItemList/AudioEffects])
	menu_item_list.set("AudioMusic", [selection_type.SLIDER, $ItemList/AudioMusic])
	menu_item_list.set("Back To Main", [selection_type.BASIC, $ItemList/Back2Main])
	
	var first_item = menu_item_list.get(entries[0])
	if first_item[0] == selection_type.BASIC:
		first_item[1].label_settings = current_effect
	else:
		first_item[1].selected_slider(true)

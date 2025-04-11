extends TextureRect

# Silly little script to make addressing these things easier

## Make the heart visible
func healed() -> void:
	$Heart.visible = true

## Make the heart invisible, showing the dot behind it
func hurt() -> void:
	$Heart.visible = false

extends Node2D
class_name Key_Aura

func set_color(col: Color) -> void:
	$GPUParticles2D.process_material.color = col

extends Node2D
class_name Key

@export var key_color: Color = Color("red")

func _ready() -> void:
	$StaticBody2D/GPUParticles2D.process_material.display.color = key_color

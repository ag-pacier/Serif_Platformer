extends Node2D



func _on_test_trigger_trigger_trip(body) -> void:
	$TestTrigger/GPUParticles2D.emitting = true

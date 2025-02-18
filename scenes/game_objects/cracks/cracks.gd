extends Area3D
class_name Cracks

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		GameEvents.on_crack_step.emit()

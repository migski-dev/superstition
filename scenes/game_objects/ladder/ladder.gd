extends Area3D
class_name Ladder

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		GameEvents.on_ladder_step.emit()

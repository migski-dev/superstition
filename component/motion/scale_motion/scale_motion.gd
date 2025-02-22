## Original File MIT License Copyright (c) 2024 TinyTakinTeller
## [br][br]
## Set export variables to get a desired animation effect. (Inherited from [Motion].)
## [br][br]
## Use [add_motion] func to increment scale. It will start returning to the original over time.
class_name ScaleMotion
extends Motion


func _ready() -> void:
	super.initialize(Control)


func _motion_transform(target: Node) -> void:
	target.scale = _original_target_values[target] * motion_factor


func _set_target_original_values(target: Node) -> void:
	_original_target_values[target] = target.scale

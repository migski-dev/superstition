## Original File MIT License Copyright (c) 2024 TinyTakinTeller
## [br][br]
## Specialization of [Builder] script that builds ui scenes: [MenuScene], [GameScene].
## - Targets [Control] nodes with [focus_mode] property that is not [Control.FocusMode.FOCUS_NONE].
## - Exceptions are nodes of types: [Tree], [GameButton].
## - Attaches to targets the following components: [TwistMotion], [ControlFocusOnHover].
class_name UiBuilder
extends Builder


func _ready() -> void:
	customize = {}
	customize["SaveFileButton"] = {
		TwistMotion:
		{"offset_target_level": 2, "max_motion_factor": 0.975, "max_rotation_degrees": 1.25}
	}
	customize["CodeTextEdit"] = {
		TwistMotion:
		{"offset_target_level": 2, "max_motion_factor": 0.988, "max_rotation_degrees": 0.625}
	}

	initialize(Control, [Tree ])#, GameButton])

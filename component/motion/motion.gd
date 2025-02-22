## Original File MIT License Copyright (c) 2024 TinyTakinTeller
## [br][br]
## Base script for all motion components.
## Uses a tween to animate some properties of given target nodes.
## Override _get_target_original_value and _motion_transform to setup custom properties motion.
## NOTE: Maybe it is better to use [AnimationPlayer] instead of tweens.
## NOTE: Maybe it is better to use a resource script instead of export variables.
## [br][br]
## Set export variables to get a desired animation effect.
## [br][br]
## Use [add_motion] func to increment property. It will start returning to the original over time.
class_name Motion
extends Node

signal motion_end

@export_category("Target")
@export var target_children: bool = false
@export var targets: Array[Node] = []
## If larger than 0, sets target to "parent of the parent" ... (that many levels upwards).
## Still keeps triggers of "original target" (level 0).
@export var offset_target_level: int = 0

@export_category("Triggers")
@export var trigger_signals: Array[String]

@export_category("Motion")
@export var min_motion_factor: float = 1.0
@export var max_motion_factor: float = 1.5
## If set to 0, will use max motion factor as default.
@export var add_motion_default: float = 0.0
@export var motion_duration: float = 0.4
@export var center_pivot: bool = false

@export_category("Tween")
## See: https://www.reddit.com/r/godot/comments/14gt180
@export var transition_type: Tween.TransitionType = Tween.TransitionType.TRANS_LINEAR
@export var ease_type: Tween.EaseType = Tween.EaseType.EASE_IN

var motion_factor: float = min_motion_factor

var _original_target_values: Dictionary = {}
var _motion_tween: Tween = null


func _ready() -> void:
	initialize(null)


func initialize(target_type: Variant) -> void:
	if target_type == null:
		return

	if _is_targets_empty():
		var filter: Array = get_parent().get_children() if target_children else [get_parent()]
		for child: Node in filter:
			var target: Node = child
			if is_instance_of(target, target_type):
				var offset_target: Node = NodeUtils.get_grandparent(target, offset_target_level)
				targets.append(offset_target)
				_set_target_original_values(offset_target)

				for trigger_signal: String in trigger_signals:
					target.connect(trigger_signal, add_motion)

	if center_pivot:
		for target: Node in targets:
			target.resized.connect(_on_resized.bind(target))
			_on_resized(target)


func add_motion(motion_factor_increment: float = add_motion_default) -> void:
	if add_motion_default == 0.0:
		motion_factor_increment = max_motion_factor

	if _is_targets_empty():
		#LogWrapper.debug(self, "No targets set.")
		return

	if motion_factor_increment > 0:
		motion_factor = min(max_motion_factor, motion_factor + motion_factor_increment)
	else:
		motion_factor = max(min_motion_factor, motion_factor + motion_factor_increment)
	reset_motion_tween()


func reset_motion_tween() -> void:
	if _motion_tween != null:
		_motion_tween.kill()
	_motion_tween = create_tween().set_trans(transition_type).set_ease(ease_type)
	_motion_tween.tween_method(
		_motion_tween_method, motion_factor, min_motion_factor, motion_duration
	)
	_motion_tween.tween_callback(_motion_tween_callback)


func _motion_tween_method(factor: float) -> void:
	motion_factor = factor
	for target: Node in targets:
		_motion_transform(target)


func _motion_transform(_target: Node) -> void:
	pass


func _set_target_original_values(target: Node) -> void:
	_original_target_values[target] = target


func _motion_tween_callback() -> void:
	motion_end.emit()


func _is_targets_empty() -> bool:
	return targets == null or targets.is_empty()


func _on_resized(target: Node) -> void:
	if "pivot_offset" in target and "size" in target:
		target.pivot_offset = target.size / 2

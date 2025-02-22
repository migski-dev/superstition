## Original File MIT License Copyright (c) 2024 TinyTakinTeller
## [br][br]
## Emits audio events on target slider signals (drag started, drag ended).
## [br][br]
## Attach to parent node.
class_name SliderAudio
extends Node

## Sets target as parent if target is not already set.
@export var target: Slider

@export_category("Sounds")
@export var drag_started: AudioEnum.Sfx = AudioEnum.Sfx.SELECT
@export var drag_ended: AudioEnum.Sfx = AudioEnum.Sfx.CLICK


func _ready() -> void:
	if target == null:
		target = get_parent()

	_connect_signals()


func _connect_signals() -> void:
	target.drag_started.connect(_on_target_drag_started)
	target.drag_ended.connect(_on_target_drag_ended)


func _on_target_drag_started() -> void:
	if _is_set(drag_started):
		AudioWrapper.play_sfx(drag_started)

	#LogWrapper.debug(self, "Slider sfx drag started: ", AudioEnum.sfx_name(drag_started))


func _on_target_drag_ended(_value_changed: bool) -> void:
	if _is_set(drag_ended):
		AudioWrapper.play_sfx(drag_ended)

	#LogWrapper.debug(self, "Slider sfx drag ended: ", AudioEnum.sfx_name(drag_ended))


func _is_set(event: AudioEnum.Sfx) -> bool:
	return target != null and event != AudioEnum.Sfx.NULL

## Original File MIT License Copyright (c) 2024 TinyTakinTeller
## [br][br]
## Makes target node theme [StyleBox] expand to fill parent control.
## [br][br]
## Modifies the theme override. If not found at node level, will look at the inherited theme.
class_name ControlExpandStylebox
extends Node

## Uses parent as target if not set. (e.g. [HSlider])
@export var target: Control
@export var theme_override_property: String = "theme_override_styles/slider"
@export var theme_inherited_property: String = "HSlider/styles/slider"

@export var expand_factor: float = 0.5:
	set(value):
		expand_factor = value
		_refresh_size()

var _parent_control: Control


func _ready() -> void:
	if target == null:
		target = get_parent()

	_connect_signals()


func _refresh_size() -> void:
	if _parent_control == null:
		return

	var override_slider: StyleBox = target.get(theme_override_property) as StyleBox
	if override_slider != null:
		return _resize_slider(override_slider)

	var inherited_theme: Theme = ThemeUtils.get_inherited_theme(target)
	if inherited_theme == null:
		return

	var theme_slider: StyleBox = inherited_theme.get(theme_inherited_property) as StyleBox
	if theme_slider != null:
		override_slider = theme_slider.duplicate()
		target.set(theme_override_property, override_slider)
		return _resize_slider(override_slider)


func _resize_slider(stlye_box: StyleBox) -> void:
	stlye_box.content_margin_top = int(float(_parent_control.size.y) * expand_factor / 2)
	stlye_box.content_margin_bottom = int(float(_parent_control.size.y) * expand_factor / 2)


func _connect_signals() -> void:
	if _parent_control != null:
		return

	var parent: Node = target.get_parent()
	if parent != null and is_instance_of(parent, Control):
		_parent_control = parent as Control
		_parent_control.resized.connect(_on_parent_control_resized)
		_parent_control.visibility_changed.connect(_on_parent_control_resized)


func _on_parent_control_resized() -> void:
	_refresh_size()

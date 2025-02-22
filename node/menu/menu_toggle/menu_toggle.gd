## Original File MIT License Copyright (c) 2024 TinyTakinTeller
## [br][br]
## Localized toggle button that emits a global signal.
@tool
class_name MenuToggle
extends MarginContainer

@export var id: MenuToggleEnum.ID = MenuToggleEnum.ID.UNKNOWN

@export var label: String:
	set(value):
		label = value
		_refresh_labels()

@export var label_on: String:
	set(value):
		label_on = value
		_refresh_labels()

@export var label_off: String:
	set(value):
		label_off = value
		_refresh_labels()

@export var padding_spaces: int = 7:
	set(value):
		padding_spaces = value
		_refresh_labels()

@onready var label_label: Label = %LabelLabel

@onready var toggle_button: Button = %ToggleButton


func _ready() -> void:
	_connect_signals()
	set_value()


func set_value(enabled: bool = false) -> void:
	toggle_button.button_pressed = enabled
	_refresh_labels()


func _refresh_labels() -> void:
	if label_label == null:
		label_label = %LabelLabel
	label_label.text = "Audio"

	if toggle_button == null:
		toggle_button = %ToggleButton
	if toggle_button.button_pressed:
		toggle_button.text = "On"
	else:
		toggle_button.text = "Off"
	toggle_button.text = StringUtils.add_padding(toggle_button.text, padding_spaces)


func _connect_signals() -> void:
	if Engine.is_editor_hint():
		return

	#SignalBus.language_changed.connect(_on_language_changed)

	toggle_button.pressed.connect(_on_check_button_toggled)


func _on_language_changed(_locale: String) -> void:
	_refresh_labels()


func _on_check_button_toggled() -> void:
	#LogWrapper.debug(self, "Menu toggle ID '%s' toggled." % [MenuToggleEnum.ID.keys()[id]])

	_refresh_labels()

	if id == null or id == MenuToggleEnum.ID.UNKNOWN:
		return
	SignalBus.menu_toggle_value_changed.emit(id, toggle_button.button_pressed, self)

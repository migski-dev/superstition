## Original File MIT License Copyright (c) 2024 TinyTakinTeller
## [br][br]
## Localized slider with accessibility buttons that emit a global signal.
@tool
class_name MenuSlider
extends MarginContainer

@export var id: MenuSliderEnum.ID = MenuSliderEnum.ID.UNKNOWN

@export var min_value: float = 0
@export var max_value: float = 100

@export var update_on_release: bool = false

@export var value_suffix: String = ""

@export var label: String = "":
	set(value):
		label = value
		_refresh_label()

@export var slider_stretch_ratio: float = 1.0:
	set(value):
		slider_stretch_ratio = value
		_initialize()

var _last_value: float

@onready var label_label: Label = %LabelLabel
@onready var value_label: Label = %ValueLabel

@onready var h_slider: HSlider = %HSlider
@onready var decrement_slider_button: Button = %DecrementSliderButton
@onready var decrement_step_slider_button: Button = %DecrementStepSliderButton
@onready var increment_slider_button: Button = %IncrementSliderButton
@onready var increment_step_slider_button: Button = %IncrementStepSliderButton
@onready var slider_margin_container: MarginContainer = %SliderMarginContainer


func _ready() -> void:
	_connect_signals()
	#_refresh_label()
	_initialize()
	set_value()


func set_value(value: float = 0) -> void:
	_last_value = value
	h_slider.value = value
	_refresh_value()


func _initialize() -> void:
	if h_slider == null or slider_margin_container == null:
		return
	h_slider.min_value = min_value
	h_slider.max_value = max_value
	slider_margin_container.size_flags_stretch_ratio = slider_stretch_ratio


func _refresh_label() -> void:
	if label_label == null:
		label_label = %LabelLabel
	#label_label.text = TranslationServerWrapper.translate(label)


func _refresh_value() -> void:
	value_label.text = str(int(h_slider.value)) + value_suffix


func _connect_signals() -> void:
	if Engine.is_editor_hint():
		return

	#SignalBus.language_changed.connect(_on_language_changed)

	h_slider.value_changed.connect(_on_slider_value_changed)
	h_slider.drag_ended.connect(_on_slider_drag_ended)
	decrement_slider_button.pressed.connect(_on_slider_value_added.bind(-10.0))
	decrement_step_slider_button.pressed.connect(_on_slider_value_added.bind(-1.0))
	increment_slider_button.pressed.connect(_on_slider_value_added.bind(10.0))
	increment_step_slider_button.pressed.connect(_on_slider_value_added.bind(1.0))


func _on_language_changed(_locale: String) -> void:
	_refresh_label()


func _on_slider_drag_ended(value_changed: bool) -> void:
	if not value_changed:
		return
	if not update_on_release:
		return

	var value: float = h_slider.value

	#LogWrapper.debug(self, "Menu slider ID '%s' value changed." % [MenuSliderEnum.ID.keys()[id]])

	_refresh_value()

	if id == null or id == MenuSliderEnum.ID.UNKNOWN:
		return
	SignalBus.menu_slider_value_changed.emit(id, value, self)


func _on_slider_value_changed(value: float) -> void:
	if update_on_release:
		return
	_on_slider_value_added(h_slider.value - value)


func _on_slider_value_added(increment: float) -> void:
	var value: float = min(h_slider.max_value, max(h_slider.min_value, h_slider.value + increment))
	if value == _last_value:
		return

	#LogWrapper.debug(self, "Menu slider ID '%s' value changed." % [MenuSliderEnum.ID.keys()[id]])

	_last_value = value
	if h_slider.value != value:
		h_slider.value = value
	_refresh_value()

	if id == null or id == MenuSliderEnum.ID.UNKNOWN:
		return
	SignalBus.menu_slider_value_changed.emit(id, value, self)

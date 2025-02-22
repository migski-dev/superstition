## Original File MIT License Copyright (c) 2024 TinyTakinTeller
## [br][br]
## Localized option button that emits a global signal.
@tool
class_name MenuDropdown
extends MarginContainer

@export var id: MenuDropdownEnum.ID = MenuDropdownEnum.ID.UNKNOWN

@export var label: String:
	set(value):
		label = value
		_refresh_label()

@export var option_padding: int = 1

var _options: Array[String]
var _disabled_options: Dictionary
var _hide_disabled: bool

var _overriden_focus_mode: FocusMode
var _overriden_option_index: int = -1

@onready var label_label: Label = %LabelLabel

@onready var option_button: OptionButton = %OptionButton


func _ready() -> void:
	_connect_signals()
	_refresh_label()


func disable(override_value: String = "") -> void:
	override_value = StringUtils.add_padding(override_value, option_padding)

	if option_button.disabled:
		if override_value != "":
			option_button.set_item_text(option_button.selected, override_value)
		return

	option_button.disabled = true
	_overriden_focus_mode = option_button.focus_mode
	option_button.focus_mode = FocusMode.FOCUS_NONE

	if override_value != "":
		option_button.add_item(override_value)
		_overriden_option_index = option_button.selected
		set_option(option_button.item_count - 1)


func enable() -> void:
	if not option_button.disabled:
		return

	option_button.disabled = false
	option_button.focus_mode = _overriden_focus_mode

	if _overriden_option_index != -1:
		option_button.remove_item(option_button.item_count - 1)
		set_option(_overriden_option_index)
		_overriden_option_index = -1


func init_options(
	options: Array[String], disabled_options: Dictionary = {}, hide_disabled: bool = false
) -> void:
	_options = options
	_disabled_options = disabled_options
	_hide_disabled = hide_disabled
	_refresh_options()


func get_option() -> int:
	return option_button.selected


func set_option(index: int = -1) -> void:
	if index >= option_button.item_count:
		#LogWrapper.debug(self, "Index out of bounds: ", index)
		return
	option_button.select(index)


func _refresh_size() -> void:
	option_button.get_popup().visible = false


func _refresh_options() -> void:
	var selected_index: int = get_option()
	option_button.clear()
	for option: String in _options:
		var is_disabled: bool = _disabled_options.get(option, false)
		#var localized_text: String = TranslationServerWrapper.translate(option)
		if is_disabled and _hide_disabled:
			continue
		option_button.add_item(StringUtils.add_padding(option, option_padding))
		var item_index: int = option_button.item_count - 1
		option_button.set_item_disabled(item_index, is_disabled)
	set_option(selected_index)


func _refresh_label() -> void:
	if label_label == null:
		label_label = %LabelLabel
	#label_label.text = TranslationServerWrapper.translate(label)


func _connect_signals() -> void:
	if Engine.is_editor_hint():
		return

	#SignalBus.language_changed.connect(_on_language_changed)

	option_button.item_selected.connect(_on_option_button_item_selected)

	get_tree().get_root().size_changed.connect(_on_root_size_changed)


func _on_language_changed(_locale: String) -> void:
	_refresh_label()
	_refresh_options()


func _on_option_button_item_selected(index: int) -> void:
	#LogWrapper.debug(self, "Menu dropdown ID '%s' idx '%s'." % [MenuDropdownEnum.ID.keys()[id], index])

	if id == null or id == MenuDropdownEnum.ID.UNKNOWN:
		return
	SignalBus.menu_dropdown_option_selected.emit(id, index, self)


func _on_root_size_changed() -> void:
	_refresh_size.call_deferred()

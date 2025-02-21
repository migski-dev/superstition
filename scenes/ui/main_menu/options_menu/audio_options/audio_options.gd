## Original File MIT License Copyright (c) 2024 TinyTakinTeller
## [br][br]
## Manages global audio options.
extends MarginContainer

var _action_handler: ActionHandler = ActionHandler.new()

@onready var master_menu_slider: MenuSlider = %MasterMenuSlider
@onready var music_menu_slider: MenuSlider = %MusicMenuSlider
@onready var sfx_menu_slider: MenuSlider = %SFXMenuSlider
@onready var audio_menu_toggle: MenuToggle = %AudioMenuToggle


func _ready() -> void:
	_connect_signals()
	_init_action_handler()
	_load_audio_options()


func _load_audio_options() -> void:
	var master_volume: float = Configuration.audio.get_master_volume()
	var music_volume: float = Configuration.audio.get_music_volume()
	var sfx_volume: float = Configuration.audio.get_sfx_volume()
	var audio_enabled: bool = Configuration.audio.get_audio_enabled()

	master_menu_slider.set_value(master_volume)
	music_menu_slider.set_value(music_volume)
	sfx_menu_slider.set_value(sfx_volume)
	audio_menu_toggle.set_value(audio_enabled)


func _init_action_handler() -> void:
	_action_handler.set_register_type("MenuSlider")
	_action_handler.register_actions(
		{
			MenuSliderEnum.ID.AUDIO_MASTER: _action_master_menu_slider,
			MenuSliderEnum.ID.AUDIO_MUSIC: _action_music_menu_slider,
			MenuSliderEnum.ID.AUDIO_SFX: _action_sfx_menu_slider
		}
	)

	_action_handler.set_register_type("MenuToggle")
	_action_handler.register_action(MenuToggleEnum.ID.AUDIO, _action_audio_menu_toggle)

	_action_handler.set_register_type("MenuButton")
	_action_handler.register_action(MenuButtonEnum.ID.OPTIONS_MENU_RESET, _action_reset_menu_button)


func _action_master_menu_slider(value: float) -> void:
	Configuration.audio.set_master_volume(value)


func _action_music_menu_slider(value: float) -> void:
	Configuration.audio.set_music_volume(value)


func _action_sfx_menu_slider(value: float) -> void:
	Configuration.audio.set_sfx_volume(value)


func _action_audio_menu_toggle(enabled: bool) -> void:
	Configuration.audio.set_audio_enabled(enabled)


func _action_reset_menu_button() -> void:
	if not is_visible_in_tree():
		return

	Configuration.audio.reset()
	_load_audio_options()


func _connect_signals() -> void:
	SignalBus.menu_slider_value_changed.connect(_on_menu_slider_value_changed)
	SignalBus.menu_toggle_value_changed.connect(_on_menu_toggle_value_changed)
	SignalBus.menu_button_pressed.connect(_on_menu_button_pressed)


func _on_menu_slider_value_changed(
	id: MenuSliderEnum.ID, value: float, _source: MenuSlider
) -> void:
	_action_handler.handle_action_args("MenuSlider", id, self, [value])


func _on_menu_toggle_value_changed(
	id: MenuToggleEnum.ID, enabled: bool, _source: MenuToggle
) -> void:
	_action_handler.handle_action_args("MenuToggle", id, self, [enabled])


func _on_menu_button_pressed(id: MenuButtonEnum.ID, _source: MenuButtonClass) -> void:
	_action_handler.handle_action("MenuButton", id, self)

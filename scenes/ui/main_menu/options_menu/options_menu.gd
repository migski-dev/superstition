## Original File MIT License Copyright (c) 2024 TinyTakinTeller
## [br][br]
## Holds options scenes and manages their transitions (listens to menu button pressed signal).
class_name OptionsMenu
extends Control

var _current_menu: Control = null
var _action_handler: ActionHandler = ActionHandler.new()

@onready var tab_h_box_container: HBoxContainer = %TabHBoxContainer

@onready var audio_options: MarginContainer = %AudioOptions
#@onready var video_options: MarginContainer = %VideoOptions
#@onready var controls_options: MarginContainer = %ControlsOptions
#@onready var game_options: MarginContainer = %GameOptions

#@onready var game_menu_button: MenuButtonClass = %GameMenuButton


func _ready() -> void:
	_connect_signals()
	_toggle_options(audio_options, tab_h_box_container.get_child(0))
	_init_action_handler()

	#LogWrapper.debug(self, "MenuScene: Options Menu ready.")


func _init_action_handler() -> void:
	_action_handler.set_register_type("MenuButton")
	_action_handler.register_actions(
		{
			MenuButtonEnum.ID.OPTIONS_MENU_AUDIO_TAB: _action_audio_menu_button,
			#MenuButtonEnum.ID.OPTIONS_MENU_VIDEO_TAB: _action_video_menu_button,
			#MenuButtonEnum.ID.OPTIONS_MENU_CONTROLS_TAB: _action_controls_menu_button,
			#MenuButtonEnum.ID.OPTIONS_MENU_GAME_TAB: _action_game_menu_button
		}
	)


func _action_audio_menu_button(source: MenuButtonClass) -> void:
	_toggle_options(audio_options, source)


#func _action_video_menu_button(source: MenuButtonClass) -> void:
	#_toggle_options(video_options, source)
#
#
#func _action_controls_menu_button(source: MenuButtonClass) -> void:
	#_toggle_options(controls_options, source)
#
#
#func _action_game_menu_button(source: MenuButtonClass) -> void:
	#_toggle_options(game_options, source)


func _toggle_options(menu: Control, source: MenuButtonClass) -> void:
	if menu == _current_menu:
		if source != null:
			source.button_pressed = true
		return

	menu.visible = true
	if _current_menu != null:
		_current_menu.visible = false
	_current_menu = menu

	if source != null:
		_unpress_tabs_except(source)


func _unpress_tabs_except(menu_button: MenuButtonClass) -> void:
	for child: Node in tab_h_box_container.get_children():
		if is_instance_of(child, MenuButtonClass) and child != menu_button:
			(child as MenuButtonClass).button_pressed = false
	menu_button.button_pressed = true


func _connect_signals() -> void:
	self.visibility_changed.connect(_on_visibility_changed)
	SignalBus.menu_button_pressed.connect(_on_menu_button_pressed)


func _on_visibility_changed() -> void:
	if is_visible_in_tree():
		_toggle_options(audio_options, tab_h_box_container.get_child(0))


func _on_menu_button_pressed(id: MenuButtonEnum.ID, source: MenuButtonClass) -> void:
	_action_handler.handle_action_args("MenuButton", id, self, [source])

## Original File MIT License Copyright (c) 2024 TinyTakinTeller
## [br][br]
## Holds menu scenes and manages their transitions (listens to menu button pressed signal).
class_name MenuScene
extends Control

var _current_menu: Control = null
var _action_handler: ActionHandler = ActionHandler.new()
var start_scene: PackedScene = preload("res://scenes/main/main.tscn")


@onready var main_menu: MainMenu = %MainMenu
@onready var options_menu: OptionsMenu = %OptionsMenu
@onready var credits_menu: CreditsMenu = %CreditsMenu
#@onready var save_files_menu: SaveFilesMenu = %SaveFilesMenu


# Return to main menu if inside any of the sub-menus.
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("game_pause"):
		if not main_menu.visible:
			_action_main_menu_back()


func _ready() -> void:
	_connect_signals()
	_toggle_menu(main_menu)
	_init_action_handler()

	await MusicManager.loaded
	AudioWrapper.play_music(AudioEnum.Music.MENU_DOODLE_2_LOOP, 1.0)


func _init_action_handler() -> void:
	_action_handler.set_register_type("MenuButton")
	_action_handler.register_actions(
		{
			MenuButtonEnum.ID.MAIN_MENU_PLAY: _action_main_menu_play,
			MenuButtonEnum.ID.MAIN_MENU_OPTIONS: _action_main_menu_options,
			MenuButtonEnum.ID.MAIN_MENU_CREDITS: _action_main_menu_credits,
			MenuButtonEnum.ID.MAIN_MENU_QUIT: _action_main_menu_quit
		}
	)
	_action_handler.register_same_action(
		[
			MenuButtonEnum.ID.OPTIONS_MENU_BACK,
			MenuButtonEnum.ID.CREDITS_MENU_BACK,
			MenuButtonEnum.ID.SAVE_FILES_MENU_BACK
		],
		_action_main_menu_back
	)


func _action_main_menu_play() -> void:
	await get_tree().create_timer(.5).timeout
	var start_level = start_scene.instantiate()
	get_tree().root.add_child(start_level)
	get_tree().current_scene = start_level
	get_tree().root.remove_child(self)
	queue_free()


func _action_main_menu_options() -> void:
	_toggle_menu(options_menu)


func _action_main_menu_credits() -> void:
	_toggle_menu(credits_menu)
	credits_menu.credits.reset()


func _action_main_menu_quit() -> void:
	get_tree().quit()


func _action_main_menu_back() -> void:
	_toggle_menu(main_menu)


func _toggle_menu(menu: Control) -> void:
	menu.visible = true
	if _current_menu != null:
		_current_menu.visible = false
	_current_menu = menu


func _connect_signals() -> void:
	SignalBus.menu_button_pressed.connect(_on_menu_button_pressed)


func _on_menu_button_pressed(id: MenuButtonEnum.ID, _source: MenuButtonClass) -> void:
	_action_handler.handle_action("MenuButton", id, self)

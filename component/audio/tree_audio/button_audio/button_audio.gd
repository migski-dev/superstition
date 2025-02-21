## Original File MIT License Copyright (c) 2024 TinyTakinTeller
## [br][br]
## Emits audio events on target button signals (focus, click, release).
## [br][br]
## Attach to parent node. (Will target parent or sibling of type [BaseButton].)
class_name ButtonAudio
extends Node

enum Interaction { NULL, FOCUS, DOWN, UP }

## Sets target as parent if target is not already set.
## If parent is not instance of [BaseButton], searches for a sibling instead (recursively).
## While searching for target, ignores nodes that already have a [ButtonAudio] attached.
@export var target: BaseButton

@export_category("Sounds")
@export var focus: AudioEnum.Sfx = AudioEnum.Sfx.SELECT
@export var down: AudioEnum.Sfx = AudioEnum.Sfx.SELECT
@export var up: AudioEnum.Sfx = AudioEnum.Sfx.CLICK

@export_category("Interaction Options")
## Consider focus is grabbed by a script instead by an interaction.
@export var skip_focus_on_nothing_pressed: bool = true
## Consider focus and down sfx are triggered at the same time.
@export var skip_down_after_focus: bool = true
## Consider [OptionButton] emits button_up signal at the same frame as the button_down signal.
@export var skip_up_for_option_button: bool = true
@export var last_interaction_timeout: float = 0.1

var _last_interaction: Interaction = Interaction.NULL

@onready var last_interaction_timer: Timer = %LastInteractionTimer


func _ready() -> void:
	last_interaction_timer.wait_time = last_interaction_timeout

	if target == null:
		target = _get_parent_or_sibling(get_parent())
	if target == null:
		#LogWrapper.debug(self, "Target not found for parent: ", get_parent().name)
		return

	target.add_theme_constant_override("button_audio_attached", 1)
	_connect_signals()


func _is_valid_target(node: Node) -> bool:
	if not "get_theme_constant" in node:
		return false
	var is_aready_a_target: bool = node.get_theme_constant("button_audio_attached") == 1
	return is_instance_of(node, BaseButton) and not is_aready_a_target


func _get_parent_or_sibling(parent: Node) -> Node:
	if _is_valid_target(parent):
		return parent
	for sibling: Node in parent.get_children(true):
		if _is_valid_target(sibling):
			return sibling
		var base_button: BaseButton = _get_parent_or_sibling(sibling)
		if base_button != null:
			return base_button
	return null


func _connect_signals() -> void:
	last_interaction_timer.timeout.connect(_on_clear_last_interaction)
	target.visibility_changed.connect(_on_clear_last_interaction)

	target.focus_entered.connect(_on_target_focus_entered)
	target.button_down.connect(_on_target_button_down)
	target.button_up.connect(_on_target_button_up)

	if is_instance_of(target, OptionButton):
		(target as OptionButton).get_popup().id_focused.connect(_on_target_option_focus_entered)
		(target as OptionButton).get_popup().id_pressed.connect(_on_target_option_button_up)


func _on_clear_last_interaction() -> void:
	_last_interaction = Interaction.NULL


func _on_target_focus_entered() -> void:
	if skip_focus_on_nothing_pressed and not Input.is_anything_pressed():
		return
	if _is_set(focus):
		AudioWrapper.play_sfx(focus)
	_new_interaction(Interaction.FOCUS)

	#LogWrapper.debug(self, "Button sfx focus: ", AudioEnum.sfx_name(focus))


func _on_target_button_down() -> void:
	if skip_down_after_focus and _last_interaction == Interaction.FOCUS:
		return
	if _is_set(down):
		AudioWrapper.play_sfx(down)
	_new_interaction(Interaction.DOWN)

	#LogWrapper.debug(self, "Button sfx down: ", AudioEnum.sfx_name(down))


func _on_target_button_up(internal: bool = false) -> void:
	if not internal and skip_up_for_option_button and is_instance_of(target, OptionButton):
		return
	if _is_set(up):
		AudioWrapper.play_sfx(up)
	_new_interaction(Interaction.UP)

	#LogWrapper.debug(self, "Button sfx up: ", AudioEnum.sfx_name(up))


func _on_target_option_focus_entered(_id: int) -> void:
	_on_target_focus_entered()


func _on_target_option_button_up(_id: int) -> void:
	_on_target_button_up(true)


func _new_interaction(interaction: Interaction) -> void:
	if last_interaction_timeout > 0.0:
		last_interaction_timer.start()
	_last_interaction = interaction


func _is_set(event: AudioEnum.Sfx) -> bool:
	return target != null and event != AudioEnum.Sfx.NULL

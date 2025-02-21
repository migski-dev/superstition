## Original File MIT License Copyright (c) 2024 TinyTakinTeller
class_name LanguageOptionButton
extends OptionButton


func _ready() -> void:
	_connect_signals()
	_init_options()

	self.get_popup().max_size.y = get_viewport().size.y - self.size.y - 32


func _init_options() -> void:
	#var locale_text: LinkedMap = Configuration.locale.get_locale_text()
	var current_locale: String = TranslationServer.get_locale()
	var current_index: int = -1
	self.clear()
	for locale: String in ["Play", "Options", "Credits", "Quit"]:
		#self.add_item(locale_text.get_value(locale))
		if locale == current_locale:
			current_index = self.item_count - 1
	self.select(current_index)


func _connect_signals() -> void:
	self.item_selected.connect(_on_language_option_button_item_select)
	get_tree().get_root().size_changed.connect(_on_root_size_changed)
	SignalBus.language_changed.connect(_on_language_changed)


#func _on_language_option_button_item_select(index: int) -> void:
	#var locale_text: LinkedMap = Configuration.locale.get_locale_text()
	#var locale: String = locale_text.get_key_at(index)
	#Configuration.locale.set_locale(locale)


# https://github.com/godotengine/godot/issues/100613
func _on_root_size_changed() -> void:
	self.get_popup().visible = false


#func _on_language_changed(_locale: String) -> void:
	##var language_option_index: int = Configuration.locale.get_locale_option_index()
	#self.select(language_option_index)

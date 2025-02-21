## Original File MIT License Copyright (c) 2024 TinyTakinTeller
extends Node

## UI
signal menu_button_pressed(id: MenuButtonEnum.ID, source: MenuButtonClass)
signal menu_slider_value_changed(id: MenuSliderEnum.ID, value: float, source: MenuSlider)
signal menu_toggle_value_changed(id: MenuToggleEnum.ID, enabled: bool, source: MenuToggle)
signal menu_dropdown_option_selected(id: MenuDropdownEnum.ID, index: int, source: MenuDropdown)

## Configuration
# Language change needs to propagate to all localized nodes.
#signal language_changed(locale: String)
## External cause of display mode change occured (For example, Fullscreen toggle on windows window).
#signal configuration_display_mode_reloaded(index: int)
## Custom scale (resize) scripts need to be aware of display size changes.
#signal configuration_display_size_changed(
	#window_mode: DisplayServer.WindowMode, window_size: Vector2i
#)
# Game custom configuration for displaying integer values.
#signal number_format_changed(number_format: NumberUtils.NumberFormat)

## Game
#signal clicks_per_second_updated(clicks: int)

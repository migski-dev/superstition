extends Control

@onready var game_over_reason_label = $Panel/MarginContainer/VBoxContainer/Label

func _ready():
	GameEvents.on_game_over.connect(_on_game_over)

func _on_button_pressed() -> void:
	Engine.time_scale = 1
	get_tree().reload_current_scene()

func _on_game_over()-> void:
	game_over_reason_label.text = GameEvents.game_over_reason

extends Node3D

@onready var game_over_ui = $CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	game_over_ui.visible = false
	GameEvents.connect("on_game_over", _on_game_over)

func _on_game_over():
	Engine.time_scale = 0
	game_over_ui.visible = true

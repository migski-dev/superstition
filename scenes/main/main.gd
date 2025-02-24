extends Node3D

@onready var meme_layer:CanvasLayer = $MemeLayer
@onready var viewport:Viewport = get_viewport()
@onready var game_size: Vector2 = Vector2(ProjectSettings.get_setting('display/window/size/viewport_width'), ProjectSettings.get_setting('display/window/size/viewport_height'))
var test: Array

# Called when the node enters the scene tree for the first time.
func _ready():
	viewport.size_changed.connect(_center_game)
	#game_over_ui.visible = false
	meme_layer.visible = false

	GameEvents.connect("on_game_over", _on_game_over)
	GameEvents.sister = $Sister
	GameEvents.player = $Player
	_center_game()
	#AudioWrapper.stop_music()
	#AudioWrapper.play_music(AudioEnum.Music.BGM, 1.0, false)

func _on_game_over():
	Engine.time_scale = 0
	#game_over_ui.visible = true
	meme_layer.visible = true

func _center_game():
	var game_offset = (viewport.get_visible_rect().size - game_size) / 2
	viewport.canvas_transform.origin = game_offset

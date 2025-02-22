extends Node3D

@onready var game_over_ui = $GameOverLayer
@onready var meme_layer = $MemeLayer
var test: Array

# Called when the node enters the scene tree for the first time.
func _ready():
	game_over_ui.visible = false
	meme_layer.visible = false
	GameEvents.connect("on_game_over", _on_game_over)
	GameEvents.sister = $Sister
	GameEvents.player = $Player
	AudioWrapper.stop_music()
	AudioWrapper.play_music(AudioEnum.Music.BGM, 1.0, false)

func _on_game_over():
	Engine.time_scale = 0
	game_over_ui.visible = true
	meme_layer.visible = true

extends Node3D

signal on_game_over()
var game_over_reason: String

var game_speed: float = 3.0
var game_speed_rate_of_change: float = 2.0

func _physics_process(delta):
	game_speed+= game_speed_rate_of_change*delta / 400

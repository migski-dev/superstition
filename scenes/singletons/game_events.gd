extends Node3D

signal on_game_over()
signal on_crack_step()
signal on_ladder_step()
signal on_sister_lost()

var game_over_reason: String
var game_speed: float = 4.0
var game_speed_rate_of_change: float = 2.0
var sister: Friend 
var head_position: float = 0.0
var head_module: Node3D
var module_offset: float = 6.0
var initial_offset: float = 0.0


func _physics_process(delta):
	head_position -= game_speed*delta

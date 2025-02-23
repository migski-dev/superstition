extends Node3D

signal on_game_over()
signal on_crack_step()
signal on_ladder_step()
signal on_sister_lost()
signal on_pole_split()
signal on_black_cat()

var game_over_reason: String = ""
var game_speed: float = 4.0
var game_speed_rate_of_change: float = 2.0
var sister: Friend
var player: Player
var head_position: float = 0.0
var head_module: Node3D
var module_offset: float = 6.0
var initial_offset: float = 0.0

var slow_mo: bool = false

func stop_game():
	game_speed = 0.0
	await get_tree().create_timer(1.5).timeout
	GameEvents.game_speed = 4.0
	Engine.time_scale = .1
	await get_tree().create_timer(0.15).timeout
	Engine.time_scale = 1
	on_game_over.emit()
	
	#GameEvents.slow_mo = true
	#await get_tree().create_timer(1.0).timeout
	#GameEvents.slow_mo = false
	#GameEvents.game_speed = 4.0
	#
#func _physics_process(delta):
	#if slow_mo:
		#game_speed += .1*delta

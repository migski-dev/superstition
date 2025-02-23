extends Control
var splash_cat: Texture = preload("res://assets/memes/death_splash_cat.png")
var splash_pole: Texture = preload("res://assets/memes/death_splash_pole.png")
var splash_crack: Texture = preload("res://assets/memes/death_splash_crack.png")
var splash_lost: Texture = preload("res://assets/memes/death_splash_crack.png")
var splash_ladder: Texture = preload("res://assets/memes/death_splash_ladder.png")
var current_texture: Texture


func _ready():
	GameEvents.on_game_over.connect(_on_game_over)
	%DeathSplashCat.visible = false
	%DeathSplashPole.visible = false
	%DeathSplashLadder.visible = false
	%DeathSplashCrack.visible = false


func _on_game_over()->void:
	%Label.text = GameEvents.game_over_reason
	match GameEvents.game_over_reason:
		"YOU CROSSED PATH WITH A BLACK CAT": 
			%DeathSplashCat.visible = true
			#%DeathSplashCrack.texture = splash_cat
		"YOU SPLIT THE POLE":
			%DeathSplashPole.visible = true
		"YOU STEPPED ON A CRACK":
			%DeathSplashCrack.visible = true
		"YOU WENT UNDER A LADDER":
			%DeathSplashLadder.visible = true
		"YOU LOST YOUR SISTER":
			%DeathSplashCat.visible = true
		

func _on_button_pressed() -> void:
	Engine.time_scale = 1
	get_tree().reload_current_scene()


	

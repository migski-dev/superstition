extends Control

@onready var score: int = 0
@onready var game_over: bool = false

func _ready() -> void:
	GameEvents.on_black_cat.connect(_pause_score)
	GameEvents.on_pole_split.connect(_pause_score)
	GameEvents.on_crack_step.connect(_pause_score)
	GameEvents.on_ladder_step.connect(_pause_score)
	GameEvents.on_sister_lost.connect(_pause_score)

func _physics_process(delta) -> void:
	if not game_over:
		score += 3
		%ScoreLabel.text = StringUtils.join(["Score: ", str(score)]) 
		

func _pause_score() -> void:
	game_over = true

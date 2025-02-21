extends Control

@onready var score: int = 0


func _process(delta):
	score += 3
	$ScoreLabel.text = StringUtils.join(["Score: ", str(score)]) 

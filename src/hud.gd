extends CanvasLayer

@onready var score_label = $ScoreLabel

func update_score(value):
	score_label.text =str(value)

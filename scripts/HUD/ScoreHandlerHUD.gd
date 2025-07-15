extends Control

@export var score_handler : ScoreHandler

@onready var current_score_label : Label = %CurrentScoreLabel

func _ready() -> void:
	score_handler.score_updated.connect(_on_score_updated)
	
func _update_current_score_label() -> void:
	current_score_label.text = str(score_handler.current_score)	

func _on_score_updated() -> void:
	_update_current_score_label()

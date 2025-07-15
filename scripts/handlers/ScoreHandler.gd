class_name ScoreHandler
extends Node2D

signal score_updated

@export var task_handler : TaskHandler

@export var coin_pickup_score : int = 50
@export var enemy_defeat_score : int = 100
@export var task_finished_score : int = 500
@export var task_failed_score : int = -800

@export var gold_enemy_defeat_multipler : float = 1.5

var current_score : int = 0

func _ready() -> void:
	GlobalSignalBus.game_start.connect(_on_game_reset)
	GlobalSignalBus.retry.connect(_on_game_reset)
	
	GlobalSignalBus.coin_collected.connect( _change_score.bind(coin_pickup_score) )
	GlobalSignalBus.enemy_death.connect(_on_enemy_death )
	task_handler.task_finished.connect( _on_task_finished )
	GlobalCardTimer.timeout.connect( _change_score.bind(task_failed_score) )

func _change_score(amt : int) -> void:
	current_score += amt
	score_updated.emit()

func _on_enemy_death(is_gold : bool) -> void:
	var score : int = enemy_defeat_score
	score = score if not is_gold else score * gold_enemy_defeat_multipler
	
	_change_score(score)

func _on_task_finished() -> void:
	var score : int = task_finished_score * ( 1 + GlobalCardTimer.time_left / Global.MAX_TIME_LIMIT)
	_change_score(score)

func _on_game_reset() -> void:
	current_score = 0
	score_updated.emit()

class_name EnemyDefeatTask
extends Task

@export var need_golden_enemy : bool

func _init() -> void:
	GlobalSignalBus.enemy_death.connect(_on_enemy_death)

func _on_enemy_death(is_gold : bool) -> void:
	if need_golden_enemy and not is_gold:
		return
	
	_on_task_progress_made()

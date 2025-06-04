extends Node2D

const MAX_WAIT_TIME : float = 15

@onready var progress_bar : TextureProgressBar = $%progress_bar

func _ready() -> void:
	progress_bar.max_value = MAX_WAIT_TIME

func _process(delta : float) -> void:
	var time_left : float = GlobalCardTimer.time_left
	
	progress_bar.value = time_left
	
	if time_left < MAX_WAIT_TIME / 4:
		progress_bar.tint_progress = Color8(255, 0, 0, 255)
	else:
		progress_bar.tint_progress = Color8(255, 255, 255, 255)

extends Node2D

const MAX_WAIT_TIME : float = 15

@onready var progress_bar : TextureProgressBar = $%progress_bar

@onready var timer_sfx : AudioStreamPlayer = $TimerSfx

func _ready() -> void:
	progress_bar.max_value = MAX_WAIT_TIME
	
	GlobalSignalBus.game_start.connect(_on_game_start)

func _process(delta : float) -> void:
	var time_left : float = GlobalCardTimer.time_left
	
	progress_bar.value = time_left
	
	if time_left < MAX_WAIT_TIME / 4:
		progress_bar.tint_progress = Color8(255, 0, 0, 255)
	else:
		progress_bar.tint_progress = Color8(255, 255, 255, 255)

func _on_game_start() -> void:
	GlobalCardTimer.start(MAX_WAIT_TIME)

func _on_progress_bar_value_changed(value : float) -> void:
	timer_sfx.play()

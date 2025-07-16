class_name TimerController
extends Node2D

signal low_time

@onready var progress_bar : TextureProgressBar = $%progress_bar
@onready var timer_sfx : AudioStreamPlayer = $TimerSfx

var _low_time_flag : bool = false

func _ready() -> void:
	progress_bar.max_value = Global.MAX_TIME_LIMIT
	
	GlobalSignalBus.game_start.connect(_on_game_start)
	GlobalSignalBus.timer_hidden.connect(_on_timer_hidden)
	GlobalSignalBus.card_changed.connect(_on_card_changed)

func _process(delta : float) -> void:
	var time_left : float = GlobalCardTimer.time_left

	progress_bar.value = time_left
	
	if time_left < Global.MAX_TIME_LIMIT / 2:
		progress_bar.tint_progress = Color8(255, 0, 0, 255)
		timer_sfx.pitch_scale = 1.2
		GlobalBackgroundMusic.change_playback_speed(1)
		
		if not _low_time_flag:
			low_time.emit()
			_low_time_flag = true
	else:
		progress_bar.tint_progress = Color8(255, 255, 255, 255)
		timer_sfx.pitch_scale = 1.0
		GlobalBackgroundMusic.change_playback_speed(1)

func _on_game_start() -> void:
	GlobalCardTimer.start(Global.MAX_TIME_LIMIT)
	_low_time_flag = false

func _on_timer_hidden(phidden : bool) -> void:
	visible = not phidden

func _on_card_changed() -> void:
	GlobalCardTimer.start()

func _on_progress_bar_value_changed(value : float) -> void:
	timer_sfx.play()

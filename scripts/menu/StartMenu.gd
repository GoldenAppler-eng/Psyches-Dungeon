extends Menu

@export var idle_menu : Menu

@onready var start_blink_timer : Timer =  %StartBlinkTimer
@onready var start_label : Label = %start_label

func enter() -> void:
	super()
	
	set_game_paused(true)
	start_blink_timer.start()
	
	GlobalBackgroundMusic.play_soundtrack("start menu")
	GlobalBackgroundMusic.change_playback_speed(1)
	
func exit() -> void:
	super()
	
	set_game_paused(false)
	start_blink_timer.stop()

func process_frame(delta: float) -> Menu:
	if Input.is_action_just_pressed("start"):
		_start_game()
		return idle_menu
	
	return null
	
func process_physics(delta: float) -> Menu:
	return null

func process_input(event : InputEvent) -> Menu:
	return null
	
func _start_game() -> void:
	GlobalSignalBus.game_start.emit()
	
func _on_start_blink_timer_timeout() -> void:
	start_label.visible = not start_label.visible

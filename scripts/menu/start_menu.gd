extends Menu

@export var idle_menu : Menu

@onready var start_blink_timer : Timer =  %StartBlinkTimer
@onready var start_label : Label = %start_label

func enter() -> void:
	super()
	
	game_node.process_mode = PROCESS_MODE_DISABLED
	GlobalCardTimer.process_mode = PROCESS_MODE_DISABLED
	
	start_blink_timer.start()
	
func exit() -> void:
	super()
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

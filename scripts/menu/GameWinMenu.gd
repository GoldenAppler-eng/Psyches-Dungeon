extends Menu

@export var idle_menu : Menu

@onready var replay_button: Button = %replay_button

var retried := false

func init(pgame_node : Node) -> void:
	super(pgame_node)
	
	replay_button.pressed.connect(_retry_game)

func enter() -> void:
	super()
	
	retried = false
	
	set_game_paused(true)
	replay_button.grab_focus()
	
	GlobalBackgroundMusic.play_soundtrack("game win")
	GlobalBackgroundMusic.change_playback_speed(1)
	
func exit() -> void:
	super()
	
	set_game_paused(false)

func process_frame(delta : float) -> Menu:
	if retried:
		return idle_menu
	
	return null
	
func process_physics(delta : float) -> Menu:
	return null

func process_input(event : InputEvent) -> Menu:
	return null
	
func _retry_game() -> void:
	GlobalSignalBus.retry.emit()
	GlobalSignalBus.game_start.emit()
	
	retried = true

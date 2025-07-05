extends Menu

@export var pause_menu : Menu
@export var game_over_menu : Menu
@export var game_win_menu : Menu

var game_lose := false
var game_win := false

func init(game_node : Node) -> void:
	super(game_node)
	
	GlobalSignalBus.game_over.connect(_on_game_over)
	GlobalSignalBus.game_win.connect(_on_game_win)

func enter() -> void:
	game_lose = false
	game_win = false
	
func exit() -> void:
	pass

func process_frame(delta : float) -> Menu:
	if game_lose:
		return game_over_menu
		
	if game_win:
		return game_win_menu
	
	if Input.is_action_just_pressed("pause"):
		return pause_menu
	
	return null
	
func process_physics(delta : float) -> Menu:
	return null

func process_input(event : InputEvent) -> Menu:
	return null

func _on_game_over() -> void:
	game_lose = true

func _on_game_win() -> void:
	game_win = true

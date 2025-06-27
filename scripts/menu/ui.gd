extends Control

@export var game_node : Node

@onready var settings_menu : SettingsMenu = $settings_menu

@onready var retry_button : Button = %retry_button
@onready var resolution_button : Button = %resolution_button

@onready var game_over_label : Label = %game_over_label

@onready var pause_menu : Control = %pause_menu
@onready var game_over_menu : Control = %game_over_menu

var game_start := false
var game_over := false
var paused := true

@export var initial_menu : Menu
var current_menu : Menu 

var sfx_player_dict : Dictionary = {
	"ui_hover" : AudioStreamPlayer.new(),	
	"ui_pressed" : AudioStreamPlayer.new(),
	"ui_switch" : AudioStreamPlayer.new()
}

func _ready() -> void:
	change_menu(initial_menu)
	
	for menu : Menu in get_children():
		menu.init(game_node)
	
	GlobalSignalBus.game_over.connect(_on_game_over)
	GlobalSignalBus.game_win.connect(_on_game_win)
	
	for sfx : String in sfx_player_dict.keys():
		var stream_player : AudioStreamPlayer = sfx_player_dict[sfx]
		stream_player.stream = load("res://audio/sfx/" + sfx + ".wav")

		stream_player.bus = "Sfx"
		add_child(stream_player)

	install_sfx(self)

func _process(delta : float) -> void:
	var next_menu : Menu = current_menu.process_frame(delta)
	
	if next_menu:
		change_menu(next_menu)
	
	settings_menu.paused = paused
	
	if not game_start and not game_over: 
		if Input.is_action_just_pressed("start"):
			start_game()
		return
		
	if game_over:
		return	
		
	if Input.is_action_just_pressed("pause"):
		if not paused:
			resolution_button.grab_focus()
		
		paused = not paused

	if paused:
		pause_menu.visible = true

		settings_menu.visible = true
		settings_menu.process_mode = PROCESS_MODE_INHERIT
		game_node.process_mode = PROCESS_MODE_DISABLED
		GlobalCardTimer.process_mode = PROCESS_MODE_DISABLED
	else:
		pause_menu.visible = false
		
		settings_menu.visible = false
		settings_menu.process_mode = PROCESS_MODE_DISABLED
		game_node.process_mode = PROCESS_MODE_INHERIT
		GlobalCardTimer.process_mode = PROCESS_MODE_INHERIT		

func _physics_process(delta: float) -> void:
	var next_menu : Menu = current_menu.process_physics(delta)
	
	if next_menu:
		change_menu(next_menu)

func _input(event: InputEvent) -> void:
	var next_menu : Menu = current_menu.process_input(event)
	
	if next_menu:
		change_menu(next_menu)

func start_game() -> void:
	if not game_over:
		GlobalBackgroundMusic.play()
	
	game_start = true
	game_over = false
	paused = false
	
	game_over_menu.visible = false

func retry_game() -> void:
	GlobalSignalBus.retry.emit()
	GlobalSignalBus.game_start.emit()
	
	start_game()

func _on_game_over() -> void:
	game_start = false
	game_over = true
	paused = true
	
	settings_menu.visible = false
	settings_menu.process_mode = PROCESS_MODE_DISABLED
	game_node.process_mode = PROCESS_MODE_DISABLED
	GlobalCardTimer.process_mode = PROCESS_MODE_DISABLED
	
	game_over_menu.visible = true
	
	game_over_label.text = "Game over"
	retry_button.text = "Retry"
	
	retry_button.grab_focus()
	
func _on_game_win() -> void:
	game_start = false
	game_over = true
	paused = true
	
	settings_menu.visible = false
	settings_menu.process_mode = PROCESS_MODE_DISABLED
	game_node.process_mode = PROCESS_MODE_DISABLED
	GlobalCardTimer.process_mode = PROCESS_MODE_DISABLED
	
	game_over_menu.visible = true
	
	game_over_label.text = "You win"
	retry_button.text = "Replay"
	
	retry_button.grab_focus()

func install_sfx(node : Node) -> void:
	for i in node.get_children():
		if i is Button:
			var button : Button = i as Button
			
			button.focus_entered.connect( ui_sfx_play.bind("ui_hover") )			
			button.pressed.connect( ui_sfx_play.bind("ui_pressed") )
		
		if i is SettingsMenu:
			var settings : SettingsMenu = i as SettingsMenu
			
			settings.ui_switch.connect ( ui_sfx_play.bind("ui_switch") )
			
		install_sfx(i)

func ui_sfx_play(sfx : String) -> void:
	var stream_player : AudioStreamPlayer = sfx_player_dict[sfx]
	stream_player.play()

func _on_retry_button_pressed() -> void:
	retry_game()

func change_menu(next_menu : Menu) -> void:
	if current_menu:
		current_menu.exit()
	
	current_menu = next_menu
	current_menu.enter()

extends Control

@export var main_node : Node

@onready var settings_ui : SettingsUI = $settings_ui

@onready var retry_button : Button = %retry_button
@onready var resolution_button : Button = %resolution_button

@onready var game_over_label : Label = %game_over_label

@onready var pause_menu : Control = %pause_menu
@onready var start_menu : Control = %start_menu
@onready var game_over_menu : Control = %game_over_menu

var game_start := false
var game_over := false
var paused := true

var sfx_player_dict : Dictionary = {
	"ui_hover" : AudioStreamPlayer.new(),	
	"ui_pressed" : AudioStreamPlayer.new(),
	"ui_switch" : AudioStreamPlayer.new()
}

func _ready() -> void:
	main_node.process_mode = PROCESS_MODE_DISABLED
	GlobalCardTimer.process_mode = PROCESS_MODE_DISABLED

	GlobalSignalBus.game_over.connect(_on_game_over)
	GlobalSignalBus.game_win.connect(_on_game_win)
	
	for sfx : String in sfx_player_dict.keys():
		var stream_player : AudioStreamPlayer = sfx_player_dict[sfx]
		stream_player.stream = load("res://audio/sfx/" + sfx + ".wav")

		stream_player.bus = "Sfx"
		add_child(stream_player)

	install_sfx(self)

func _process(delta : float) -> void:
	settings_ui.paused = paused
	
	if not game_start and not game_over: 
		if Input.is_action_just_pressed("start"):
			start_game()
			GlobalSignalBus.game_start.emit()
		return
		
	if game_over:
		return	
		
	if Input.is_action_just_pressed("pause"):
		if not paused:
			resolution_button.grab_focus()
		
		paused = not paused

	if paused:
		pause_menu.visible = true

		settings_ui.visible = true
		settings_ui.process_mode = PROCESS_MODE_INHERIT
		main_node.process_mode = PROCESS_MODE_DISABLED
		GlobalCardTimer.process_mode = PROCESS_MODE_DISABLED
	else:
		pause_menu.visible = false
		
		settings_ui.visible = false
		settings_ui.process_mode = PROCESS_MODE_DISABLED
		main_node.process_mode = PROCESS_MODE_INHERIT
		GlobalCardTimer.process_mode = PROCESS_MODE_INHERIT		

func start_game() -> void:
	if not game_over:
		GlobalBackgroundMusic.play()
	
	game_start = true
	game_over = false
	paused = false
	
	start_menu.visible = false
	game_over_menu.visible = false

func retry_game() -> void:
	GlobalSignalBus.retry.emit()
	GlobalSignalBus.game_start.emit()
	
	start_game()

func _on_game_over() -> void:
	game_start = false
	game_over = true
	paused = true
	
	settings_ui.visible = false
	settings_ui.process_mode = PROCESS_MODE_DISABLED
	main_node.process_mode = PROCESS_MODE_DISABLED
	GlobalCardTimer.process_mode = PROCESS_MODE_DISABLED
	
	game_over_menu.visible = true
	
	game_over_label.text = "Game over"
	retry_button.text = "Retry"
	
	retry_button.grab_focus()
	
func _on_game_win() -> void:
	game_start = false
	game_over = true
	paused = true
	
	settings_ui.visible = false
	settings_ui.process_mode = PROCESS_MODE_DISABLED
	main_node.process_mode = PROCESS_MODE_DISABLED
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
		
		if i is SettingsUI:
			var settings : SettingsUI = i as SettingsUI
			
			settings.ui_switch.connect ( ui_sfx_play.bind("ui_switch") )
			
		install_sfx(i)

func ui_sfx_play(sfx : String) -> void:
	var stream_player : AudioStreamPlayer = sfx_player_dict[sfx]
	stream_player.play()

func _on_retry_button_pressed() -> void:
	retry_game()

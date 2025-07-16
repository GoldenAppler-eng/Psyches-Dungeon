extends Control

@export var game_node : Node

@export var initial_menu : Menu
var current_menu : Menu 

var sfx_player_dict : Dictionary = {
	"ui_hover" : AudioStreamPlayer.new(),	
	"ui_pressed" : AudioStreamPlayer.new(),
	"ui_switch" : AudioStreamPlayer.new()
}

func _ready() -> void:	
	for node : Node in get_children():
		if node is Menu:
			var menu : Menu = node as Menu
			menu.init(game_node)
	
	change_menu(initial_menu)
	
	create_sfx_children()
	install_sfx(self)

func _process(delta : float) -> void:
	var next_menu : Menu = current_menu.process_frame(delta)
	
	if next_menu:
		change_menu(next_menu)

func _physics_process(delta: float) -> void:
	var next_menu : Menu = current_menu.process_physics(delta)
	
	if next_menu:
		change_menu(next_menu)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("quit_game"):
		get_tree().quit()
	
	var next_menu : Menu = current_menu.process_input(event)
	
	if next_menu:
		change_menu(next_menu)

func create_sfx_children() -> void:
	for sfx : String in sfx_player_dict.keys():
		var stream_player : AudioStreamPlayer = sfx_player_dict[sfx]
		stream_player.stream = load("res://audio/sfx/" + sfx + ".wav")

		stream_player.bus = "Sfx"
		add_child(stream_player)

func install_sfx(node : Node) -> void:
	for i in node.get_children():
		if i is Button:
			var button : Button = i as Button
			
			button.focus_entered.connect( ui_sfx_play.bind("ui_hover") )			
			button.pressed.connect( ui_sfx_play.bind("ui_pressed") )
		
		if i is SwitchButton:
			var switch_button : SwitchButton = i as SwitchButton
			
			switch_button.button_switched.connect( ui_switch_sfx_play.bind("ui_switch") )
			switch_button.button_switched_pressed.connect( ui_switch_sfx_play.bind("ui_switch") )
			switch_button.button_pressed.connect( ui_sfx_play.bind("ui_pressed") )

		install_sfx(i)

func ui_sfx_play(sfx : String) -> void:
	var stream_player : AudioStreamPlayer = sfx_player_dict[sfx]
	stream_player.play()

func ui_switch_sfx_play(value : int, sfx : String) -> void:
	ui_sfx_play(sfx)

func change_menu(next_menu : Menu) -> void:
	if current_menu:
		current_menu.exit()
	
	current_menu = next_menu
	current_menu.enter()

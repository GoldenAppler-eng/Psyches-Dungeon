extends Node2D

@export var timer_controller : TimerController

var player_regeneration_component : RegenerationComponent

var heart_icons : Array[HeartIcon]

var _rightmost_heart_index : int = 0

func _ready() -> void:
	detect_icons()
	sync_heart_beats()
	
	connect_signals()
	
	player_regeneration_component = Global.global_player.find_child("RegenerationComponent")

func _physics_process(delta: float) -> void:
	if player_regeneration_component.is_regenerating() and not _rightmost_heart_index == heart_icons.size() - 1 :
		heart_icons[_rightmost_heart_index + 1].set_regen(true)
	elif not player_regeneration_component.is_regenerating():
		for heart_icon in heart_icons:
			if heart_icon.is_regenerating():
				heart_icon.set_regen(false)
	
func connect_signals() -> void:
	GlobalSignalBus.retry.connect(_on_game_retry)
	
	timer_controller.low_time.connect(_on_timer_low_time)
	GlobalCardTimer.timeout.connect(_on_global_card_timer_timeout)
	
	var player_health_component : HealthComponent = Global.global_player.find_child("HealthComponent") as HealthComponent
	player_health_component.health_lost.connect(_on_player_health_lost)
	player_health_component.health_regened.connect(_on_player_health_regened)

func detect_icons() -> void:
	for child : HeartIcon in get_children():
		heart_icons.append(child)
		
	_rightmost_heart_index = heart_icons.size() - 1

func play_faster_beating() -> void:
	for heart_icon in heart_icons:
		heart_icon.play_faster_beating(true)
		
	sync_heart_beats()

func play_regular_beating() -> void:
	for heart_icon in heart_icons:
		heart_icon.play_faster_beating(false)
		
	sync_heart_beats()
	
func sync_heart_beats() -> void:
	var frame : int = heart_icons[0].frame
	
	for heart_icon in heart_icons:
		if heart_icon.is_beating():
			heart_icon.frame = frame

func _on_timer_low_time() -> void:
	play_faster_beating()

func _on_global_card_timer_timeout() -> void:
	play_regular_beating()

func _on_player_health_lost() -> void:
	heart_icons[_rightmost_heart_index].hurt()
	_rightmost_heart_index -= 1
	
func _on_player_health_regened() -> void:
	_rightmost_heart_index += 1
	heart_icons[_rightmost_heart_index].set_beating(true)

func _on_game_retry() -> void:
	for heart_icon in heart_icons:
		heart_icon.set_beating(true)
	
	sync_heart_beats()
	
	_rightmost_heart_index = heart_icons.size() - 1

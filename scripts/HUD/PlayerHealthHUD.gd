extends Node2D

@export var timer_controller : TimerController

var heart_icons : Array[HeartIcon]

func _ready() -> void:
	detect_icons()
	sync_heart_beats()
	
	timer_controller.low_time.connect(_on_timer_low_time)
	GlobalCardTimer.timeout.connect(_on_global_card_timer_timeout)

func detect_icons() -> void:
	for child : HeartIcon in get_children():
		heart_icons.append(child)

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

extends Node

@export_range(0, 1, 0.1) var distort_drive : float = 0

@onready var screen_shader_animation_player: AnimationPlayer = %ScreenShaderAnimationPlayer
@onready var screen_distortion: ColorRect = %ScreenDistortion

var audio_distort_effect : AudioEffectDistortion

func _ready() -> void:
	GlobalSignalBus.card_changed.connect(_distort)
	
	var bus_index : int = AudioServer.get_bus_index("AudioModulator")
	audio_distort_effect = AudioServer.get_bus_effect(bus_index, 0) as AudioEffectDistortion

func _process(delta: float) -> void:
	screen_distortion.visible = Global.screen_distortion_enabled
	
	audio_distort_effect.drive = distort_drive

func _distort() -> void:
	screen_shader_animation_player.play("screen_distort")

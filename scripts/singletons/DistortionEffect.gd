extends Node

@export var card_handler : CardHandler
@export_range(0, 1, 0.1) var distort_drive : float = 0

@onready var screen_shader_animation_player: AnimationPlayer = %ScreenShaderAnimationPlayer

var audio_distort_effect : AudioEffectDistortion

func _ready() -> void:
	card_handler.card_changed.connect(_distort)
	
	var bus_index : int = AudioServer.get_bus_index("AudioModulator")
	audio_distort_effect = AudioServer.get_bus_effect(bus_index, 0) as AudioEffectDistortion

func _process(delta: float) -> void:
	audio_distort_effect.drive = distort_drive

func _distort() -> void:
	screen_shader_animation_player.play("screen_distort")

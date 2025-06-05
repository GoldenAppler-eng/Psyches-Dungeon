class_name SignalSfxPlayer
extends AudioStreamPlayer

var sfx_name : String = ""

func _ready() -> void:
	finished.connect(_on_finished)
	
func set_sfx_name(name : String) -> void:
	sfx_name = name
	
func _on_finished() -> void:
	GlobalSignalBus.sfx_finished.emit(sfx_name)


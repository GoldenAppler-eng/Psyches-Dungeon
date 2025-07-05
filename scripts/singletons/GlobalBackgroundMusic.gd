extends AudioStreamPlayer

func _ready() -> void:
	GlobalSignalBus.game_start.connect(_on_game_started)

func _on_game_started() -> void:
	play()

func _on_finished() -> void:
	play()

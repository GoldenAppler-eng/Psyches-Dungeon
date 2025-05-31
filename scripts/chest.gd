extends StaticBody2D

var _player_nearby := false
var _opened := false

func _process(delta: float) -> void:
	if not _player_nearby or _opened:
		return
		
	if Input.is_action_just_pressed("open_chest"):
		_open_chest()

func _open_chest() -> void:
	GlobalSignalBus.chest_opened.emit()
	_opened = true
	
	var rng := randf()
	
	print("Congrats you got a ")
	
	if rng < 0.8: 
		print("coins!")
	else:
		print("a new skeleton pal!")

func _on_area_2d_player_entered(body: Node2D) -> void:
	_player_nearby = true

func _on_area_2d_player_exited(body: Node2D) -> void:
	_player_nearby = false

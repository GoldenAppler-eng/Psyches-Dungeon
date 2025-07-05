extends Node2D

const CAMERA_SPEED := 1000

var rooms_entered : Array[Node2D] = []

var target_position : Vector2

var init_position : Vector2

func _ready() -> void:
	GlobalSignalBus.room_entered.connect(_on_room_entered)	
	GlobalSignalBus.room_exited.connect(_on_room_exited)
	
	GlobalSignalBus.retry.connect(_on_game_retry)
	
	init_position = global_position

func _process(delta : float) -> void:
	global_position.x = move_toward(global_position.x, target_position.x, delta * CAMERA_SPEED)	
	global_position.y = move_toward(global_position.y, target_position.y, delta * CAMERA_SPEED)

func _on_game_retry() -> void:
	global_position = init_position
	target_position = global_position
	
	rooms_entered.clear()

func _on_room_entered(room_area : Node2D) -> void:
	rooms_entered.append(room_area)
	
	target_position = rooms_entered.back().global_position
	
func _on_room_exited(room_area : Node2D) -> void:
	rooms_entered.remove_at(rooms_entered.find(room_area))
	
	if rooms_entered.is_empty():
		return
	
	target_position = rooms_entered.back().global_position

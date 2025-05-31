extends StaticBody2D

const TRAP_DAMAGE : int = 10;

@onready var reset_timer : Timer = $%ResetTimer

var activated := false
var _damaged_bodies : Array[DamagableBody2D] = []

func _process(delta : float) -> void:
	if not activated:
		modulate = Color.WHITE
		return
	
	modulate = Color.RED
	
	for body in _damaged_bodies:
		body.apply_damage(TRAP_DAMAGE)

func _on_area_2d_player_entered(body : Node2D) -> void:
	if body is DamagableBody2D:
		reset_timer.stop()
		
		if not activated:
			GlobalSignalBus.trap_activated.emit(body)
				
			activated = true
		
		if activated: 
			_damaged_bodies.append(body as DamagableBody2D)


func _on_area_2d_player_exited(body : Node2D) -> void:
	if body is DamagableBody2D:
		if _damaged_bodies.has(body):
			_damaged_bodies.remove_at(_damaged_bodies.find(body)) 
		
	if _damaged_bodies.is_empty():
		reset_timer.start()

func _on_reset_timer_timeout() -> void:
	activated = false

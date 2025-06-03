class_name Trap
extends RigidBody2D

const TRAP_DAMAGE : int = 10;

@onready var reset_timer : Timer = $%ResetTimer
@onready var animated_sprite_2d : AnimatedSprite2D = $%AnimatedSprite2D

var activated := false
var _damaged_bodies : Array[DamagableBody2D] = []

func _process(delta : float) -> void:
	if not activated:
		animated_sprite_2d.frame = 0
		return
	
	animated_sprite_2d.frame = 1
	
	for body in _damaged_bodies:
		body.apply_damage(TRAP_DAMAGE)

func _on_area_2d_body_entered(body : Node2D) -> void:
	reset_timer.stop()
	
	if not activated:
		if body is Player:
			GlobalSignalBus.trap_activated.emit(body)
			
		activated = true
	
	if activated: 
		_damaged_bodies.append(body as DamagableBody2D)


func _on_area_2d_body_exited(body : Node2D) -> void:
	if _damaged_bodies.has(body):
		_damaged_bodies.remove_at(_damaged_bodies.find(body)) 
		
	if _damaged_bodies.is_empty():
		reset_timer.start()

func _on_reset_timer_timeout() -> void:
	activated = false

class_name Player
extends DamagableBody2D

const MAX_SPEED := 30000.0

@onready var invinciblity_timer : Timer = $%InvinciblityTimer

var speed := MAX_SPEED
var invincible := false

func _ready() -> void:
	pass

func _physics_process(delta : float) -> void:
	_player_movement(delta)
	_player_anim(delta)

func _player_movement(delta : float) -> void:
	var horizontal_direction := Input.get_axis("move_left", "move_right")
	var vertical_direction := Input.get_axis("move_up", "move_down");
	
	if horizontal_direction and vertical_direction :
		speed = MAX_SPEED * sin(deg_to_rad(45))
	else: 
		speed = MAX_SPEED
		
	velocity.x = horizontal_direction * speed * delta
	velocity.y = vertical_direction * speed * delta

	move_and_slide()
	
func _player_anim(delta : float) -> void:
	var r := modulate.r
	var g := modulate.g
	var b := modulate.b
	
	if invincible:
		modulate = Color(r, g, b, 50)
	else:
		modulate = Color(r, g, b, 255)
	
func apply_damage(amt : int) -> void:
	if invincible:
		return
		
	print("Took " + str(amt) + " damage!")
	invincible = true
	invinciblity_timer.start()


func _on_invinciblity_timer_timeout() -> void:
	invincible = false

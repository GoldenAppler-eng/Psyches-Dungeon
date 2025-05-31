class_name Enemy
extends DamagableBody2D

const MAX_SPEED := 30000.0
const SCATTER_RANGE := 20.0
const SCATTER_RANGE_DISPLACEMENT_MAX := 5.0

const GOLD_CHANCE := .4

var target_position : Vector2

var speed := MAX_SPEED

var is_golden := false

func _ready() -> void:
	if randf() <= GOLD_CHANCE:
		is_golden = true
	
	generate_new_target()

func _physics_process(delta : float) -> void:
	_enemy_movement(delta)

func _enemy_movement(delta : float) -> void:
	if (global_position.distance_to(target_position) < 10):
		generate_new_target()
	
	var horizontal_direction : int = sign(target_position.x - global_position.x)
	var vertical_direction : int = sign(target_position.y - global_position.y);
	
	if horizontal_direction and vertical_direction :
		speed = MAX_SPEED * sin(deg_to_rad(45))
	else: 
		speed = MAX_SPEED
		
	velocity.x = horizontal_direction * speed * delta
	velocity.y = vertical_direction * speed * delta

	move_and_slide()

func enemy_anim() -> void:
	if is_golden:
		modulate = Color(215, 190, 0, 255)

func apply_damage(amt : int) -> void:
	pass
	
# change this later
func generate_new_target() -> void:
	var displacement := Vector2(randf_range(-SCATTER_RANGE_DISPLACEMENT_MAX, SCATTER_RANGE_DISPLACEMENT_MAX), randf_range(-SCATTER_RANGE_DISPLACEMENT_MAX, SCATTER_RANGE_DISPLACEMENT_MAX)) + Vector2(sign(randf_range(-1, 1)) * SCATTER_RANGE, sign(randf_range(-1, 1)) * SCATTER_RANGE)
	target_position = global_position + displacement

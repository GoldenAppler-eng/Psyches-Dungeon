class_name Enemy
extends DamagableBody2D

const MAX_SPEED := 10000.0
const GOLD_CHANCE := .4
const DAMAGE := 10
const KNOCKBACK_MODIFIER := 20

@export var max_health : int = 100

@onready var damager_hitbox : Area2D = $%DamagerHitbox
@onready var object_detection_area : Area2D = $%ObjectDetectionArea

@onready var attack_cooldown_timer : Timer = $%AttackCooldownTimer
@onready var invincibility_timer : Timer = $%InvincibilityTimer

@export var target_player : Player
@export var dropped_item : PackedScene

var damager_hitbox_offset : float
var speed := MAX_SPEED

var _is_golden := false
var _attack_ready := false
var _charging := false
var _invincible := false

var avoided_objects : Array[Node2D] = []

var _target_direction : Vector2

func _ready() -> void:
	health = max_health
	damager_hitbox_offset = damager_hitbox.position.x
	
	if randf() <= GOLD_CHANCE:
		_is_golden = true

func _physics_process(delta : float) -> void:	
	_check_health()
	
	var movement_direction := _enemy_movement(delta)
	
	_enemy_anim(movement_direction.x, movement_direction.y, delta)
	_enemy_attack(delta)

func _check_health() -> void:
	if health <= 0:
		_die()

func _enemy_movement(delta : float) -> Vector2:
	_get_target_direction()
	
	var horizontal_direction : float = sign(_target_direction.x)
	var vertical_direction : float = sign(_target_direction.y)
	
	if _invincible:
		horizontal_direction = 0
		vertical_direction = 0
	
	velocity.x = speed * _target_direction.x * delta
	velocity.y = speed * _target_direction.y * delta

	if horizontal_direction > 0:
		damager_hitbox.position.x = damager_hitbox_offset
	elif horizontal_direction < 0:
		damager_hitbox.position.x = -damager_hitbox_offset

	move_and_slide()
	
	return Vector2(horizontal_direction, vertical_direction)

func _get_target_direction() -> void:
	var normalized_vector2_to_player : Vector2 = (target_player.global_position - global_position).normalized()
	_target_direction = normalized_vector2_to_player
	
	for object in avoided_objects:
		if object == self:
			continue
		
		var normalized_vector2_to_object : Vector2 = (object.global_position - global_position).normalized()
		var object_direction_weight : float = normalized_vector2_to_player.dot(normalized_vector2_to_object)
			
		if object is Enemy:
			object_direction_weight = 1 - abs(object_direction_weight)
		elif object is Trap:
			var trap : Trap = object as Trap
			
			if not trap.activated:
				object_direction_weight = 0 
		else:
			#change later
			object_direction_weight = abs(object_direction_weight) 
			
		_target_direction -= object_direction_weight * normalized_vector2_to_object
	
	_target_direction = _target_direction.normalized()

func _enemy_anim(horizontal_direction : float, vertical_direction : float, delta : float) -> void:
	if _is_golden:
		modulate = Color(215, 190, 0, 255)

func _enemy_attack(delta: float) -> void:
	if damager_hitbox.has_overlapping_areas():
		if not _charging:
			_charging = true
			attack_cooldown_timer.start()
	
		if _attack_ready:
			_attack_ready = false
			
			for area in damager_hitbox.get_overlapping_areas():
				if area.owner is Player:
					var player : Player = area.owner as Player
					player.apply_damage(DAMAGE)

func _die() -> void:
	if _is_golden:
		var item : Node = dropped_item.instantiate()
		get_parent().add_child(item)
		item.global_position = global_position
		
	GlobalSignalBus.enemy_death.emit(_is_golden)
	
	queue_free()

func apply_damage(amt : int) -> void:
	if _invincible:
		return
	
	_invincible = true
	invincibility_timer.start()
	
	velocity.x = -velocity.x * KNOCKBACK_MODIFIER
	velocity.y = -velocity.y * KNOCKBACK_MODIFIER
	
	move_and_slide()
	
	health -= amt
	print("Enemy has taken " + str(amt) + " damage!")

func _on_attack_cooldown_timer_timeout() -> void:
	_attack_ready = true;
	_charging = false

func _on_invincibility_timer_timeout() -> void:
	_invincible = false

func _on_object_detection_area_body_entered(body : Node2D) -> void:
	avoided_objects.append(body)

func _on_object_detection_area_body_exited(body : Node2D) -> void:
	if avoided_objects.has(body):
		avoided_objects.remove_at(avoided_objects.find(body))

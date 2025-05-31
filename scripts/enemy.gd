class_name Enemy
extends DamagableBody2D

const MAX_SPEED := 10000.0
const GOLD_CHANCE := .4
const DAMAGE := 10
const KNOCKBACK_MODIFIER := 20
const STOP_DISTANCE := 50

@export var max_health : int = 100

@onready var damager_hitbox : Area2D = $%DamagerHitbox
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

func _ready() -> void:
	health = max_health
	damager_hitbox_offset = damager_hitbox.position.x
	
	if randf() <= GOLD_CHANCE:
		_is_golden = true

func _physics_process(delta : float) -> void:	
	_check_health()
	
	var horizontal_direction : float = sign(target_player.global_position.x - global_position.x)
	var vertical_direction : float = sign(target_player.global_position.y - global_position.y)
	
	if global_position.distance_to(target_player.global_position) < STOP_DISTANCE or _invincible:
		horizontal_direction = 0
		vertical_direction = 0
	
	_enemy_movement(horizontal_direction, vertical_direction, delta)
	_enemy_anim(horizontal_direction, vertical_direction, delta)
	_enemy_attack(delta)

func _check_health() -> void:
	if health <= 0:
		_die()

func _enemy_movement(horizontal_direction : float, vertical_direction : float, delta : float) -> void:
	velocity.x = horizontal_direction * speed * delta
	velocity.y = vertical_direction * speed * delta

	if horizontal_direction > 0:
		damager_hitbox.position.x = damager_hitbox_offset
	elif horizontal_direction < 0:
		damager_hitbox.position.x = -damager_hitbox_offset

	move_and_slide()

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

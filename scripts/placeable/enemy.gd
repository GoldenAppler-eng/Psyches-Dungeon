class_name Enemy
extends DamagableBody2D

const MAX_SPEED := 10000.0
const GOLD_CHANCE := .4
const DAMAGE := 10
const KNOCKBACK_MODIFIER := 0

@export var jump_component_prefab : PackedScene

@export var max_health : int = 100

@onready var damager_hitbox : Area2D = $%DamagerHitbox
@onready var attack_detection_area : Area2D = $%AttackDetectionArea
@onready var object_detection_area : Area2D = $%ObjectDetectionArea

@onready var attack_cooldown_timer : Timer = $%AttackCooldownTimer
@onready var invincibility_timer : Timer = $%InvincibilityTimer

@onready var animated_sprite_2d : AnimatedSprite2D = $%AnimatedSprite2D

@export var dropped_item : PackedScene

var target_player : Player

var damager_hitbox_offset : float
var attack_detection_offset : float
var speed := MAX_SPEED

var _is_golden := false
var _attack_ready := false
var _charging := false
var _invincible := false
var _is_attacking := false
var _is_dead := false

var avoided_objects : Array[Node2D] = []

var _target_direction : Vector2

func _ready() -> void:
	target_player = Global.global_player
	
	health = max_health
	damager_hitbox_offset = damager_hitbox.position.x	
	attack_detection_offset = attack_detection_area.position.x
	
	if randf() <= GOLD_CHANCE:
		_is_golden = true

func _physics_process(delta : float) -> void:	
	_check_health()
	
	if _is_dead:
		return
	
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
	
	if _invincible or _is_attacking or _charging:
		horizontal_direction = 0
		vertical_direction = 0
	
	velocity.x = speed * horizontal_direction * abs(_target_direction.x) * delta
	velocity.y = speed * vertical_direction * abs(_target_direction.y) * delta

	if horizontal_direction > 0:
		damager_hitbox.position.x = -damager_hitbox_offset		
		attack_detection_area.position.x = -attack_detection_offset
		
		animated_sprite_2d.flip_h = true
	elif horizontal_direction < 0:
		damager_hitbox.position.x = damager_hitbox_offset
		attack_detection_area.position.x = attack_detection_offset
	
		animated_sprite_2d.flip_h = false
		
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
		modulate = Color8(215, 190, 0, 255)
		
	if not _is_attacking:
		if horizontal_direction or vertical_direction:
			animated_sprite_2d.play("run")
		else:
			animated_sprite_2d.play("idle")

func _enemy_attack(delta: float) -> void:
	if damager_hitbox.has_overlapping_areas():		
		if not _charging:
			_charging = true
			attack_cooldown_timer.start()
	
		if _attack_ready:
			_attack_ready = false
			_is_attacking = true
			
			animated_sprite_2d.play("attack")
			
			for area in damager_hitbox.get_overlapping_areas():
				if area.owner is Player:
					var player : Player = area.owner as Player
					player.apply_damage(DAMAGE)
	else:
		attack_cooldown_timer.stop()
		_attack_ready = false
		_charging = false

func _die() -> void:
	_is_dead = true
	
	if _is_golden:
		var item : Node = dropped_item.instantiate()
		var jump_comp : Node = jump_component_prefab.instantiate()
		
		get_parent().add_child(item)	
		item.add_child(jump_comp)
		
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


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "attack":
		_is_attacking = false

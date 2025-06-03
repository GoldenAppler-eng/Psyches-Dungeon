class_name Player
extends DamagableBody2D

const MAX_SPEED := 30000.0
const DAMAGE := 10

@onready var invinciblity_timer : Timer = $%InvinciblityTimer
@onready var attack_cooldown_timer : Timer = $%AttackCooldownTimer
@onready var damager_hitbox: Area2D = $%DamagerHitbox

@onready var animated_sprite_2d : AnimatedSprite2D = $%AnimatedSprite2D

var speed := MAX_SPEED

var speed_modifier : float = 1

var _invincible := false
var _attack_ready := true
var _is_attacking := false

var damager_hitbox_offset : float 

func _ready() -> void:
	Global.global_player = self
	
	damager_hitbox_offset = damager_hitbox.position.x

func _physics_process(delta : float) -> void:
	var horizontal_direction := Input.get_axis("move_left", "move_right")
	var vertical_direction := Input.get_axis("move_up", "move_down");
	
	if _is_attacking:
		speed_modifier = 0.5
	
	_player_movement(horizontal_direction, vertical_direction, delta)
	_player_anim(horizontal_direction, vertical_direction, delta)
	_player_attack(delta)

func _player_movement(horizontal_direction : float, vertical_direction : float, delta : float) -> void:
	if horizontal_direction and vertical_direction :
		speed = MAX_SPEED * sin(deg_to_rad(45))
	else: 
		speed = MAX_SPEED
	
	speed *= speed_modifier
		
	velocity.x = horizontal_direction * speed * delta
	velocity.y = vertical_direction * speed * delta

	if horizontal_direction > 0:
		damager_hitbox.position.x = -damager_hitbox_offset;
		animated_sprite_2d.flip_h = true
	elif horizontal_direction < 0:
		damager_hitbox.position.x = damager_hitbox_offset;
		animated_sprite_2d.flip_h = false

	move_and_slide()
	
func _player_anim(horizontal_direction : float, vertical_direction : float, delta : float) -> void:
	var r := modulate.r
	var g := modulate.g
	var b := modulate.b
	
	if not _is_attacking:
		if horizontal_direction or vertical_direction:
			animated_sprite_2d.play("run")
		else:
			animated_sprite_2d.play("idle")
	
func _player_attack(delta : float) -> void:
	if not _attack_ready:
		return
	
	if Input.is_action_pressed("attack"):
		_is_attacking = true
		_attack_ready = false
		attack_cooldown_timer.start()
		
		animated_sprite_2d.play("attack")
		
		for area in damager_hitbox.get_overlapping_areas():
			if area.owner is Enemy:
				var enemy : Enemy = area.owner as Enemy
				enemy.apply_damage(DAMAGE)
	
func apply_damage(amt : int) -> void:
	if _invincible:
		return
		
	print("Took " + str(amt) + " damage!")
	_invincible = true
	invinciblity_timer.start()

func _on_invinciblity_timer_timeout() -> void:
	_invincible = false

func _on_attack_cooldown_timer_timeout() -> void:
	_attack_ready = true

func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "attack":
		_is_attacking = false

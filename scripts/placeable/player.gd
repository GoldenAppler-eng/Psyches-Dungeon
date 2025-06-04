class_name Player
extends DamagableBody2D

const MAX_HEALTH := 100
const MAX_SPEED := 20000.0
const DAMAGE := 20

const REGEN_RATE := 20

@onready var invinciblity_timer : Timer = $%InvinciblityTimer
@onready var attack_cooldown_timer : Timer = $%AttackCooldownTimer
@onready var regen_start_timer : Timer = $%RegenStartTimer
@onready var regen_timer : Timer = $%RegenTimer
@onready var health_bar_visible_timer : Timer = $%HealthBarVisibleTimer

@onready var damager_hitbox: Area2D = $%DamagerHitbox

@onready var top_half_sprite : AnimatedSprite2D = $%TopHalf
@onready var bottom_half_sprite : AnimatedSprite2D = $%BottomHalf

@onready var health_bar : TextureProgressBar = $%health_bar

var speed := MAX_SPEED

var speed_modifier : float = 1

var _invincible := false
var _attack_ready := true
var _is_attacking := false
var _is_dead := false
var _regen_ready := false

var _processing_card := false

var damager_hitbox_offset : float 

func _ready() -> void:
	GlobalCardTimer.timeout.connect(_on_global_card_timer_timeout)
	
	Global.global_player = self
	
	damager_hitbox_offset = damager_hitbox.position.x

	health = MAX_HEALTH

func _physics_process(delta : float) -> void:
	if _is_dead:
		return
	
	_update_health()
	
	var horizontal_direction := Input.get_axis("move_left", "move_right")
	var vertical_direction := Input.get_axis("move_up", "move_down");
		
	if _is_dead:
		return
		
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
		
		top_half_sprite.flip_h = true		
		bottom_half_sprite.flip_h = true
	elif horizontal_direction < 0:
		damager_hitbox.position.x = damager_hitbox_offset;
		
		top_half_sprite.flip_h = false		
		bottom_half_sprite.flip_h = false

	move_and_slide()
	
func _player_anim(horizontal_direction : float, vertical_direction : float, delta : float) -> void:
	var r := modulate.r
	var g := modulate.g
	var b := modulate.b
	
	if not _is_attacking:
		if horizontal_direction or vertical_direction:
			_play_animation("run")
		else:
			_play_animation("idle")
	else:
		if horizontal_direction or vertical_direction:
			bottom_half_sprite.play("run")
		else:
			bottom_half_sprite.play("attack")
			bottom_half_sprite.frame = top_half_sprite.frame
	
func _player_attack(delta : float) -> void:
	if not _attack_ready:
		return
	
	if Input.is_action_pressed("attack"):
		_is_attacking = true
		_attack_ready = false
		attack_cooldown_timer.start()
		
		_play_animation("attack")
		
		for area in damager_hitbox.get_overlapping_areas():
			if area.owner is Enemy:
				var enemy : Enemy = area.owner as Enemy
				enemy.apply_damage(DAMAGE)
	
func apply_damage(amt : int) -> void:
	if _invincible or _is_dead:
		return
	
	health -= amt
		
	_invincible = true
	
	invinciblity_timer.start()
	
	regen_start_timer.stop()
	regen_timer.stop()

func _die() -> void:
	_is_dead = true
	
	GlobalSignalBus.player_death.emit()
	
	top_half_sprite.play("death")
	bottom_half_sprite.visible = false

func _update_health() -> void:
	health = clamp(health, 0, MAX_HEALTH)
		
	health_bar.value = health
	
	if health < MAX_HEALTH:
		health_bar.visible = true
	
	if health <= 0:
		_die()

func _regen_health() -> void:
	health += REGEN_RATE

func _on_invinciblity_timer_timeout() -> void:
	_invincible = false
	
	regen_start_timer.start()

func _on_attack_cooldown_timer_timeout() -> void:
	_attack_ready = true

func _on_top_half_animation_finished() -> void:
	if top_half_sprite.animation == "attack":
		_is_attacking = false
		
func _play_animation(anim_name : String) -> void:
	top_half_sprite.play(anim_name)
	bottom_half_sprite.play(anim_name)
	
	top_half_sprite.frame = bottom_half_sprite.frame

func _on_global_card_timer_timeout() -> void:
	pass

func _on_regen_start_timer_timeout() -> void:
	regen_timer.start()
	
func _on_regen_timer_timeout() -> void:
	_regen_health()
	
	if health >= MAX_HEALTH:
		regen_timer.stop()
		
		health_bar_visible_timer.start()

func _on_health_bar_visible_timer_timeout() -> void:
	health_bar.visible = false

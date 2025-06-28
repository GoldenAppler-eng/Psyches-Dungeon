class_name Player
extends DamagableBody2D

const MAX_HEALTH := 100
const MAX_SPEED := 15000.0
const DAMAGE := 20

const REGEN_RATE := 20

@onready var invinciblity_timer : Timer = $%InvinciblityTimer
@onready var attack_cooldown_timer : Timer = $%AttackCooldownTimer
@onready var regen_start_timer : Timer = $%RegenStartTimer
@onready var regen_timer : Timer = $%RegenTimer
@onready var health_bar_visible_timer : Timer = $%HealthBarVisibleTimer
@onready var game_over_timer : Timer = $%GameOverTimer
@onready var respawn_timer : Timer = $%RespawnTimer

@onready var damager_hitbox: Area2D = $%DamagerHitbox

@onready var top_half_sprite : AnimatedSprite2D = $%TopHalf
@onready var bottom_half_sprite : AnimatedSprite2D = $%BottomHalf

@onready var hit_sfx : AudioStreamPlayer = $HitSfx

@onready var hit_animation_player : AnimationPlayer = %HitAnimationPlayer

@onready var health_bar : TextureProgressBar = $%health_bar

var speed := MAX_SPEED

var _invincible := false
var _is_attacking := false
var _is_respawning := false
var _is_dead := false
var _regen_ready := false

var damager_hitbox_offset : float 

var init_position : Vector2 

func _ready() -> void:
	GlobalSignalBus.player_respawn.connect(_on_received_player_respawn_signal)
	GlobalSignalBus.revert_controls.connect(_on_revert_controls)
	GlobalSignalBus.shift_controls.connect(_on_revert_controls)
	GlobalSignalBus.invert_controls.connect(_on_revert_controls)
	GlobalSignalBus.retry.connect(_on_game_retry)
	
	GlobalCardTimer.timeout.connect(_on_global_card_timer_timeout)
	
	Global.global_player = self
	
	damager_hitbox_offset = damager_hitbox.position.x
	init_position = global_position
	
	health = MAX_HEALTH

func _physics_process(delta : float) -> void:
	if _is_dead:
		return
	
	_update_health()
	
	var horizontal_direction := Input.get_axis("move_left", "move_right")
	var vertical_direction := Input.get_axis("move_up", "move_down");
	
	if _is_dead or _is_respawning:
		return
		
	_player_movement(horizontal_direction, vertical_direction, delta)
	_player_anim(horizontal_direction, vertical_direction, delta)

func _player_movement(horizontal_direction : float, vertical_direction : float, delta : float) -> void:
	if horizontal_direction and vertical_direction :
		speed = MAX_SPEED * sin(deg_to_rad(45))
	else: 
		speed = MAX_SPEED
			
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
	if _invincible:
		hit_animation_player.play("hit")
	
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
	
func apply_damage(amt : int) -> void:
	if _invincible or _is_dead:
		return
	
	hit_sfx.play()
	
	health -= amt
		
	_invincible = true
	hit_animation_player.play("hit")
	
	invinciblity_timer.start()
	
	regen_start_timer.stop()
	regen_timer.stop()

func _die() -> void:
	if _is_respawning:
		return
	
	_is_dead = true
	
	GlobalSignalBus.player_death.emit()
	
	top_half_sprite.play("death")
	bottom_half_sprite.visible = false

	game_over_timer.start()

func _respawn() -> void:
	_is_dead = false
	_invincible = true
	_is_respawning = true
	
	health = MAX_HEALTH
	
	top_half_sprite.play("respawn")
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

func _on_game_retry() -> void:
	global_position = init_position
	
	health = MAX_HEALTH
	
	_invincible = false
	_is_attacking = false
	_is_respawning = false
	_is_dead = false
	_regen_ready = false
	
	bottom_half_sprite.visible = true
	top_half_sprite.visible = true
	
	_play_animation("idle")
	
	invinciblity_timer.stop()
	attack_cooldown_timer.stop()
	regen_start_timer.stop()
	health_bar_visible_timer.stop()
	regen_timer.stop()
	game_over_timer.stop()

func _on_invinciblity_timer_timeout() -> void:
	_invincible = false
	
	regen_start_timer.start()
	
	hit_animation_player.play("RESET")

func _on_top_half_animation_finished() -> void:
	if top_half_sprite.animation == "attack":
		_is_attacking = false
		
	if top_half_sprite.animation == "respawn":
		bottom_half_sprite.visible = true		
		_is_respawning = false

		invinciblity_timer.start()
		
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

func _on_received_player_respawn_signal() -> void:
	respawn_timer.start()
	game_over_timer.stop()

func _on_game_over_timer_timeout() -> void:
	GlobalSignalBus.game_over.emit()

func _on_respawn_timer_timeout() -> void:
	_respawn()
	game_over_timer.stop()

func _on_revert_controls() -> void:
	Input.action_release("move_down")
	Input.action_release("move_up")
	Input.action_release("move_right")
	Input.action_release("move_left")
	

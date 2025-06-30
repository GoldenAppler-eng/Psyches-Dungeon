class_name Player
extends DamagableBody2D

@onready var health_bar_visible_timer : Timer = $%HealthBarVisibleTimer
@onready var respawn_timer : Timer = $%RespawnTimer

@onready var damager_hitbox: Area2D = $%DamagerHitbox

@onready var hit_animation_player : AnimationPlayer = %HitAnimationPlayer

@onready var health_bar : TextureProgressBar = $%health_bar

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
		
	Global.global_player = self
	
	damager_hitbox_offset = damager_hitbox.position.x
	init_position = global_position
	
func _physics_process(delta : float) -> void:
	if _is_dead:
		return
	
	_update_health()
	
	var horizontal_direction := Input.get_axis("move_left", "move_right")
	var vertical_direction := Input.get_axis("move_up", "move_down");
		
func _die() -> void:
	if _is_respawning:
		return
	
	_is_dead = true
	
	GlobalSignalBus.player_death.emit()

func _respawn() -> void:
	_is_dead = false
	_invincible = true
	_is_respawning = true


func _update_health() -> void:
	health_bar.value = health
	
	if health <= 0:
		_die()


func _on_game_retry() -> void:
	global_position = init_position
		
	_invincible = false
	_is_attacking = false
	_is_respawning = false
	_is_dead = false
	_regen_ready = false
		
	health_bar_visible_timer.stop()

func _on_invinciblity_timer_timeout() -> void:
	_invincible = false
		
	hit_animation_player.play("RESET")

func _on_top_half_animation_finished() -> void:
	if top_half_sprite.animation == "attack":
		_is_attacking = false
		
	if top_half_sprite.animation == "respawn":
		bottom_half_sprite.visible = true		
		_is_respawning = false

func _on_health_bar_visible_timer_timeout() -> void:
	health_bar.visible = false

func _on_received_player_respawn_signal() -> void:
	respawn_timer.start()

func _on_game_over_timer_timeout() -> void:
	GlobalSignalBus.game_over.emit()

func _on_respawn_timer_timeout() -> void:
	_respawn()

func _on_revert_controls() -> void:
	Input.action_release("move_down")
	Input.action_release("move_up")
	Input.action_release("move_right")
	Input.action_release("move_left")
	

extends RigidBody2D

@onready var pickup_sfx : AudioStreamPlayer = %PickupSfx
@onready var pickup_area : Area2D = %PickupArea
@onready var animated_sprite_2d : AnimatedSprite2D = %AnimatedSprite2D
@onready var gpu_particles_2d : GPUParticles2D = %GPUParticles2D

var _sfx_finished_flag : bool = false
var _particles_finished_flag : bool = false

func _process(delta : float) -> void:
	if _sfx_finished_flag and _particles_finished_flag:
		queue_free.call_deferred()

func _on_area_2d_player_entered(body : Node2D) -> void:
	GlobalSignalBus.coin_collected.emit()
	
	pickup()

func pickup() -> void:
	pickup_sfx.play()
	gpu_particles_2d.emitting = true
	
	animated_sprite_2d.visible = false
	set_deferred("monitoring", false)

func _on_pickup_sfx_finished() -> void:
	_sfx_finished_flag = true

func _on_gpu_particles_2d_finished() -> void:
	_particles_finished_flag = true

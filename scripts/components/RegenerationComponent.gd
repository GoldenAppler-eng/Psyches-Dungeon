class_name RegenerationComponent
extends Node2D

signal full_regeneration_finished

@export var health_component : HealthComponent

@export var regeneration_start_timer : Timer
@export var regeneration_step_timer : Timer

@export var regen_amt : int = 10

var override_regen : bool = false
var continuous_regen : bool = false

func _ready() -> void:
	regeneration_start_timer.timeout.connect(_on_regeneration_start_timer_timeout)
	regeneration_step_timer.timeout.connect(_on_regeneration_step_timer_timeout)	
	
func _process(delta: float) -> void:
	if not continuous_regen:
		return
	
	if health_component.is_health_full() and not is_regenerating() and regeneration_start_timer.is_stopped():
		regeneration_start_timer.start()
	
func start_regeneration() -> void:
	regeneration_start_timer.start()

func start_continuous_regen() -> void:
	start_regeneration()
	
	continuous_regen = true

func start_override_regeneration() -> void:
	start_regeneration()
	
	override_regen = true
	
func stop_regeneration() -> void:
	if override_regen:
		return
	
	regeneration_start_timer.stop()
	regeneration_step_timer.stop()
	
func stop_override_regneration() -> void:
	override_regen = false
	
	stop_regeneration()
	
func stop_continuous_regeneration() -> void:
	continuous_regen = false
	
	stop_regeneration()	
	
func _on_regeneration_start_timer_timeout() -> void:
	regeneration_step_timer.start()

func _on_regeneration_step_timer_timeout() -> void:
	regenerate_health(regen_amt)
		
	if health_component.is_health_full():
		stop_regeneration()
		full_regeneration_finished.emit()

func regenerate_health(amt : int) -> void:
	health_component.change_health(amt)

func is_regenerating() -> bool:
	return not regeneration_step_timer.is_stopped()

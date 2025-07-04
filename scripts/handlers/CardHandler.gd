class_name CardHandler
extends Node2D

signal card_changed
signal card_text_updated

@export var effect_pool : Array[WildEffect]

@export var task_handler : TaskHandler
@export var effect_handler : EffectHandler
@export var goal_handler : GoalHandler

var next : CardResource
var current : CardResource
var cover : CardResource

@onready var task_failed_sfx : AudioStreamPlayer = $TaskFailedSfx

func _ready() -> void:
	next = CardResource.new()
	current = CardResource.new()
	cover = CardResource.new()	
	
	GlobalCardTimer.timeout.connect(_on_new_card_timer_timeout)
	
	GlobalSignalBus.game_start.connect(_on_game_start)
	GlobalSignalBus.retry.connect(_on_game_retry)
	
	GlobalSignalBus.psyche_task_request.connect(_on_psyche_task_received)
	
	task_handler.task_finished.connect(_on_task_finished)
	
func _generate_new_next_card() -> void:
	task_handler.generate_new_next_task()	
	next.task_text = task_handler.get_next_task_description()
	card_text_updated.emit()

func _generate_new_effect() -> WildEffect:
	var chosen_effect : WildEffect = effect_pool.pick_random()
	
	return chosen_effect

func _update_current_task_text() -> void:
	current.task_text = task_handler.get_current_task_description()
	card_text_updated.emit()
	
func _change_card() -> void:
	var generated_card_effect : WildEffect = _generate_new_effect()
	
	task_handler.change_task()
	effect_handler.add_effect_to_resolve(generated_card_effect)

	_update_current_task_text()
	
	current.effect_type = generated_card_effect.effect_type
	current.effect_text = generated_card_effect.effect_name 
	
	_generate_new_next_card()
	
	card_changed.emit()

func _on_game_retry() -> void:
	_generate_new_next_card()	
	_change_card()

func _on_game_start() -> void:
	_generate_new_next_card()	
	_change_card()

func _on_new_card_timer_timeout() -> void:	
	_change_card()	
	
func _on_task_finished() -> void:
	goal_handler.mark_completed_task(current.effect_type)
	_change_card()	
	
	GlobalCardTimer.start()
	
func _on_psyche_task_received() -> void:
	task_handler.generate_new_current_task()	
	_update_current_task_text()

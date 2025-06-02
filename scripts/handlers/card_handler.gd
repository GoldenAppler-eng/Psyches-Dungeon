class_name CardHandler
extends Node2D

@export var effect_pool : Array[WildEffect]

@export var task_handler : TaskHandler
@export var effect_handler : EffectHandler
@export var goal_handler : GoalHandler
@export var loss_handler : LossHandler

@onready var next : Card = $%next
@onready var current : Card = $%current
@onready var cover : Card = $%cover

func _ready() -> void:
	GlobalCardTimer.timeout.connect(_on_new_card_timer_timeout)
	GlobalSignalBus.task_completed.connect(_on_task_completed)
	
	_generate_new_current_card()	

func _generate_new_current_card() -> void:
	var task_values : Array[int] = _generate_new_task()
	var card_effect : WildEffect = _generate_new_effect()
	
	current.task_text = "bruh"
	
	current.effect_type = card_effect.effect_type
	current.effect_text = card_effect.effect_name
	
	print(card_effect.effect_name)

func _generate_new_effect() -> WildEffect:
	var chosen_effect : WildEffect = effect_pool.pick_random()
	
	effect_handler.add_effect_to_resolve(chosen_effect)
	
	return chosen_effect

func _generate_new_task() -> Array[int]:
	var gen_task_type : int = randi_range(Global.TASK_TYPE.DEFEAT, Global.TASK_TYPE.TRAVEL)
	var gen_task_amt : int = randi_range(2, 5)
	
	task_handler.set_task_type(gen_task_type, gen_task_amt)	

	return [gen_task_type, gen_task_amt]

func _on_new_card_timer_timeout() -> void:
	loss_handler.mark_loss()
	_generate_new_current_card()	
	
func _on_task_completed(task_type : int) -> void:
	print("Complete task type: " + str(task_type))
	goal_handler.mark_completed_task(current.effect_type)
	
	_generate_new_current_card()
	GlobalCardTimer.start()

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

var next_task_values : Array[int] 
var next_card_effect : WildEffect

func _ready() -> void:
	var cover_animation_player : AnimationPlayer = cover.find_child("AnimationPlayer")
	cover_animation_player.animation_finished.connect(_on_flipping_animation_finished)
	
	GlobalCardTimer.timeout.connect(_on_new_card_timer_timeout)
	
	GlobalSignalBus.task_completed.connect(_on_task_completed)
	GlobalSignalBus.change_goal_count.connect(_on_goal_count_changed)
	GlobalSignalBus.psyche_task_request.connect(_on_psyche_task_received)
	
	_generate_new_next_card()	
	_change_cards()

func _process(delta : float) -> void:
	if Input.is_action_just_pressed("attack"):
		GlobalSignalBus.task_completed.emit(Global.TASK_TYPE.ACTIVATE)

func _generate_new_next_card() -> void:
	var task_values : Array[int] = _generate_new_task()
	var card_effect : WildEffect = _generate_new_effect()
	
	next_task_values = task_values
	next_card_effect = card_effect
	
	var task_text : String = task_handler.get_task_description(task_values[0], task_values[1], task_values[2])
	
	next.task_text = task_text
	
	next.effect_type = card_effect.effect_type
	next.effect_text = card_effect.effect_name

func _update_current_task() -> void:
	task_handler.set_task_type(next_task_values[0], next_task_values[1], next_task_values[2])
	effect_handler.add_effect_to_resolve(next_card_effect)
	
	var task_text : String = task_handler.get_current_task_description()
		
	current.task_text = task_text
	
	current.effect_type = next_card_effect.effect_type
	current.effect_text = next_card_effect.effect_name 
	
	_generate_new_next_card()

func _generate_new_effect() -> WildEffect:
	var chosen_effect : WildEffect = effect_pool.pick_random()
	
	return chosen_effect

func _generate_new_task() -> Array[int]:
	var gen_task_type : int = randi_range(Global.TASK_TYPE.DEFEAT, Global.TASK_TYPE.TRAVEL)
	var gen_task_amt : int = randi_range(2, 5)
	var gen_task_dir : int = randi_range(0, 3) + Global.DIRECTION.NORTH

	return [gen_task_type, gen_task_amt, gen_task_dir]

func _on_new_card_timer_timeout() -> void:
	loss_handler.mark_loss()
	
	_change_cards()	
	
func _on_task_completed(task_type : int) -> void:
	print("Complete task type: " + str(task_type))
	goal_handler.mark_completed_task(current.effect_type)
	
	_change_cards()	
	
	GlobalCardTimer.start()
	
func _on_goal_count_changed(inc_amt : int) -> void:
	if inc_amt > 0:
		goal_handler.add_marker()
	elif inc_amt < 0:
		goal_handler.remove_marker()
	
func _on_psyche_task_received() -> void:
	var task_values : Array[int] = _generate_new_task()
	
	task_handler.set_task_type(task_values[0], task_values[1], task_values[2])
	
	var task_text : String = task_handler.get_current_task_description()
	
	current.task_text = task_text
		
func _change_cards() -> void:
	next.visible = false
	cover.modulate = Color8(255, 255, 255, 255)
	
	cover.play_flip_card_animation()
	
func _on_flipping_animation_finished(anim_name : String) -> void:
	if anim_name == "flip_card":
		next.visible = true
		cover.modulate = Color8(255, 255, 255, 100)
		
		_update_current_task()

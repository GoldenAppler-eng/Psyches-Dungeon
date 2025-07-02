class_name Card
extends Node2D

@export var card_info : CardResource

@export var face_down : bool = false
@export var hide_effect : bool = false

@onready var base : AnimatedSprite2D = %base
@onready var effect_icon : AnimatedSprite2D = %effect_icon

@onready var task_text_label : Label = %task_text_label
@onready var effect_text_label : Label = %effect_text_label

@onready var animation_player : AnimationPlayer = %AnimationPlayer

var _is_flipping := false

func set_info(card_info : CardResource) -> void:
	self.card_info = card_info

func _process(delta : float) -> void:
	if _is_flipping:
		return
	
	if face_down:
		animation_player.play("RESET")
		return
	
	if hide_effect:
		animation_player.play("RESET_FRONT_WITHOUT_EFFECT")
	else:
		animation_player.play("RESET_FRONT")
	
	effect_icon.frame = card_info.effect_type
	
	task_text_label.text = card_info.task_text
	effect_text_label.text = card_info.seffect_text

func play_flip_card_animation() -> void:
	animation_player.play("flip_card")
	_is_flipping = true

func _on_animation_player_animation_finished(anim_name : String) -> void:
	if anim_name == "flip_card":
		_is_flipping = false

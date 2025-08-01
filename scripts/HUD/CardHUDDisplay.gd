extends Node2D

@export var card_handler : CardHandler

@onready var next : Card = %next
@onready var current : Card = %current
@onready var cover : Card = %cover

@onready var card_draw_sfx : AudioStreamPlayer = %CardDrawSfx

func _ready() -> void:
	GlobalSignalBus.card_changed.connect(_on_card_changed)
	card_handler.card_text_updated.connect(_on_card_text_updated)
	
	var cover_animation_player : AnimationPlayer = cover.find_child("AnimationPlayer")
	cover_animation_player.animation_finished.connect(_on_flipping_animation_finished)

	_set_card_infos()
		
func _on_card_changed() -> void:
	next.visible = false
	cover.modulate = Color8(255, 255, 255, 255)
	
	_set_card_infos()
	
	cover.play_flip_card_animation()
	card_draw_sfx.play()
	
func _on_card_text_updated() -> void:
	_set_card_infos()
	
func _set_card_infos() -> void:
	next.set_info(card_handler.next)
	current.set_info(card_handler.current)
	cover.set_info(card_handler.cover)
	
func _on_flipping_animation_finished(anim_name : String) -> void:
	if anim_name == "flip_card":
		next.visible = true
		cover.modulate = Color8(255, 255, 255, 100)
		
		_set_card_infos()

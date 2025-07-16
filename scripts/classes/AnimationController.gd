class_name AnimationController
extends Node

signal animation_finished(anim_name : StringName)

func init() -> void:
	extra_init()
	
	GlobalSignalBus.retry.connect(_on_game_retry)

func extra_init() -> void:
	pass

func play_animation(anim_name : StringName) -> void:
	pass
	
func play_current_animation() -> void:
	pass
	
func play_animation_overlay(overlay_name : StringName) -> void:
	pass
	
func clear_all_animation_overlay() -> void:
	pass	

func flip_animation_h(flipped : bool) -> void:
	pass
	
func _on_game_retry() -> void:
	clear_all_animation_overlay()

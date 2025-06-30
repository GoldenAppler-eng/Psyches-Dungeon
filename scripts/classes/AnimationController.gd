class_name AnimationController
extends Node

signal animation_finished(anim_name : StringName)

func init() -> void:
	extra_init()

func play_animation(anim_name : StringName) -> void:
	pass
	
func flip_animation_h(flipped : bool) -> void:
	pass

func extra_init() -> void:
	pass
